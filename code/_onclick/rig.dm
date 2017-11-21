
#define MIDDLE_CLICK 0
#define ALT_CLICK 1
#define CTRL_CLICK 2
#define MAX_HARDSUIT_CLICK_MODE 2

/client
	var/hardsuit_click_mode = MIDDLE_CLICK

/client/verb/toggle_hardsuit_mode()
	set name = "Alternar entre os modo da hardsuit"
	set desc = "Troca os modos da hardsuit."
	set category = "OOC"

	hardsuit_click_mode++
	if(hardsuit_click_mode > MAX_HARDSUIT_CLICK_MODE)
		hardsuit_click_mode = 0

	switch(hardsuit_click_mode)
		if(MIDDLE_CLICK)
			to_chat(src, "Hardsuit ativado com o botão do meio.")
		if(ALT_CLICK)
			to_chat(src, "Hardsuit ativado com o alt-click.")
		if(CTRL_CLICK)
			to_chat(src, "Hardsuit ativado com o control-click.")
		else
			// should never get here, but just in case:
			log_runtime(EXCEPTION("Bad hardsuit click mode: [hardsuit_click_mode] - expected 0 to [MAX_HARDSUIT_CLICK_MODE]"), src)
			to_chat(src, "Alguma coisa bugou o sistema. Configuarndo a Hardsuit com o botão do meio.")
			hardsuit_click_mode = MIDDLE_CLICK

/mob/living/MiddleClickOn(atom/A)
	if(client && client.hardsuit_click_mode == MIDDLE_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/living/AltClickOn(atom/A)
	if(client && client.hardsuit_click_mode == ALT_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/living/CtrlClickOn(atom/A)
	if(client && client.hardsuit_click_mode == CTRL_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/living/proc/can_use_rig()
	return 0

/mob/living/carbon/human/can_use_rig()
	return 1

/mob/living/carbon/brain/can_use_rig()
	return istype(loc, /obj/item/device/mmi)

/mob/living/silicon/ai/can_use_rig()
	return istype(loc, /obj/item/device/aicard)

/mob/living/silicon/pai/can_use_rig()
	return loc == card

/mob/living/proc/HardsuitClickOn(var/atom/A, var/alert_ai = 0)
	if(!can_use_rig() || (next_move > world.time))
		return 0
	var/obj/item/weapon/rig/rig = get_rig()
	if(istype(rig) && !rig.offline && rig.selected_module)
		if(src != rig.wearer)
			if(rig.ai_can_move_suit(src, check_user_module = 1))
				message_admins("[key_name_admin(src, include_name = 1)] está tentando forçar \the [key_name_admin(rig.wearer, include_name = 1)] à usar o modulo da Hardsuit.")
			else
				return 0
		rig.selected_module.engage(A, alert_ai)
		if(ismob(A)) // No instant mob attacking - though modules have their own cooldowns
			changeNext_move(CLICK_CD_MELEE)
		return 1
	return 0

#undef MIDDLE_CLICK
#undef ALT_CLICK
#undef CTRL_CLICK
#undef MAX_HARDSUIT_CLICK_MODE
