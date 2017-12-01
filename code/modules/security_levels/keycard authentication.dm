/obj/machinery/keycard_auth
	name = "Dispositivo de Autenticacao de Cartao-chave"
	desc = "Este dispositivo e usado para acionar funcoes da estacao, que exigem que mais de um cartao de identificacao se autentique"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"

	var/active = 0 //This gets set to 1 on all devices except the one where the initial request was made.
	var/event = ""
	var/screen = 1
	var/list/ert_chosen = list()
	var/confirmed = 0 //This variable is set by the device that confirms the request.
	var/confirm_delay = 20 //(2 seconds)
	var/busy = 0 //Busy when waiting for authentication or an event request has been sent from this device.
	var/obj/machinery/keycard_auth/event_source
	var/mob/event_triggered_by
	var/mob/event_confirmed_by
	var/ert_reason = "Reason for ERT"

	anchored = 1
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

	req_access = list(access_keycard_auth)

/obj/machinery/keycard_auth/attack_ai(mob/user as mob)
	to_chat(user, "<span class='warning'>A IA da estacao nao e para interagir com esses dispositivos.</span>")
	return

/obj/machinery/keycard_auth/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "Este dispositivo esta sem energia.")
		return
	if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))
		if(check_access(W))
			if(active == 1)
				//This is not the device that made the initial request. It is the device confirming the request.
				if(event_source)
					event_source.confirmed = 1
					event_source.event_confirmed_by = usr
			else if(screen == 2)
				if(event == "Equipe de Resposta de Emergencia" && ert_reason == "Motivo para ERT")
					to_chat(user, "<span class='notice'>Forneca um motivo para chamar a ERT primeiro!</span>")
					return
				event_triggered_by = usr
				broadcast_request() //This is the device making the initial event request. It needs to broadcast to other devices
		else
			to_chat(user, "<span class='warning'>Accesso Negado.</span>")

/obj/machinery/keycard_auth/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
		icon_state = "auth_off"
	else
		stat |= NOPOWER

/obj/machinery/keycard_auth/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/keycard_auth/attack_hand(mob/user as mob)
	if(..())
		return 1
	ui_interact(user)

/obj/machinery/keycard_auth/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(busy)
		to_chat(user, "Este dispositivo está ocupado.")
		return

	user.set_machine(src)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "keycard_auth.tmpl", "Keycard Authentication Device UI", 540, 320)
		ui.open()

/obj/machinery/keycard_auth/ui_data(mob/user, ui_key = "main", datum/topic_state/state = default_state)
	var/data[0]
	data["screen"] = screen
	data["event"] = event
	data["ertreason"] = ert_reason
	return data

/obj/machinery/keycard_auth/Topic(href, href_list)
	if(..())
		return 1

	if(busy)
		to_chat(usr, "Este dispositivo esta ocupado.")
		return

	if(href_list["triggerevent"])
		event = href_list["triggerevent"]
		screen = 2
	if(href_list["reset"])
		reset()
	if(href_list["ert"])
		ert_reason = input(usr, "Motivo para o chamado da ERT:", "", "")

	nanomanager.update_uis(src)
	add_fingerprint(usr)
	return

/obj/machinery/keycard_auth/proc/reset()
	active = 0
	event = ""
	screen = 1
	confirmed = 0
	event_source = null
	icon_state = "auth_off"
	event_triggered_by = null
	event_confirmed_by = null

/obj/machinery/keycard_auth/proc/broadcast_request()
	icon_state = "auth_on"
	for(var/obj/machinery/keycard_auth/KA in world)
		if(KA == src) continue
		KA.reset()
		spawn()
			KA.receive_request(src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_admins("[key_name_admin(event_triggered_by)] triggered and [key_name_admin(event_confirmed_by)] confirmed event [event]", 1)
	reset()

/obj/machinery/keycard_auth/proc/receive_request(var/obj/machinery/keycard_auth/source)
	if(stat & (BROKEN|NOPOWER))
		return
	event_source = source
	busy = 1
	active = 1
	icon_state = "auth_on"

	sleep(confirm_delay)

	event_source = null
	icon_state = "auth_off"
	active = 0
	busy = 0

/obj/machinery/keycard_auth/proc/trigger_event()
	switch(event)
		if("Alerta Vermelho")
			set_security_level(SEC_LEVEL_RED)
			feedback_inc("alert_keycard_auth_red",1)
		if("Conceder acesso de manutencao de emergencia")
			make_maint_all_access()
			feedback_inc("alert_keycard_auth_maintGrant",1)
		if("Revogar o acesso de manutencao de emergencia")
			revoke_maint_all_access()
			feedback_inc("alert_keycard_auth_maintRevoke",1)
		if("Equipe de Resposta de Emergencia")
			if(is_ert_blocked())
				to_chat(usr, "<span class='warning'>Todas as Equipes de Resposta de Emergencia são despachadas e nao podem ser chamadas neste momento.</span>")
				return
			to_chat(usr, "<span class = 'notice'>Pedido ERT transmitido.</span>")


			var/fullmin_count = 0
			for(var/client/C in admins)
				if(check_rights(R_EVENT, 0, C.mob))
					fullmin_count++
			if(fullmin_count)
				ert_request_answered = 0
				ERT_Announce(ert_reason , event_triggered_by, 0)
				ert_reason = "Motivo para ERT"
				feedback_inc("alert_keycard_auth_ert",1)
				spawn(3000)
					if(!ert_request_answered)
						ERT_Announce(ert_reason , event_triggered_by, 1)
			else
				trigger_armed_response_team(new /datum/response_team/amber) // No admins? No problem. Automatically send a code amber ERT.

/obj/machinery/keycard_auth/proc/is_ert_blocked()
	return ticker.mode && ticker.mode.ert_disabled

var/global/maint_all_access = 0

/proc/make_maint_all_access()
	for(var/area/maintenance/A in world)
		for(var/obj/machinery/door/airlock/D in A)
			D.emergency = 1
			D.update_icon(0)
	minor_announcement.Announce("Foram removidas as restricoes de acesso a manutencao e aos airlocks externos.")
	maint_all_access = 1

/proc/revoke_maint_all_access()
	for(var/area/maintenance/A in world)
		for(var/obj/machinery/door/airlock/D in A)
			D.emergency = 0
			D.update_icon(0)
	minor_announcement.Announce("As restricoes de acesso a manutencao e aos airlocks externos foram re-adicionadas.")
	maint_all_access = 0
