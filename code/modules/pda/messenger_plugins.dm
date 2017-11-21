/datum/data/pda/messenger_plugin
	var/datum/data/pda/app/messenger/messenger

/datum/data/pda/messenger_plugin/proc/user_act(mob/user as mob, obj/item/device/pda/P)


/datum/data/pda/messenger_plugin/virus
	name = "*Enviar Virus*"

/datum/data/pda/messenger_plugin/virus/user_act(mob/user as mob, obj/item/device/pda/P)
	var/datum/data/pda/app/messenger/M = P.find_program(/datum/data/pda/app/messenger)

	if(M && !M.toff && pda.cartridge.charges > 0)
		pda.cartridge.charges--
		return 1
	return 0


/datum/data/pda/messenger_plugin/virus/clown
	icon = "star"

/datum/data/pda/messenger_plugin/virus/clown/user_act(mob/user as mob, obj/item/device/pda/P)
	. = ..(user, P)
	if(.)
		user.show_message("<span class='notice'>Virus enviado!</span>", 1)
		P.honkamt = (rand(15,20))
		P.ttone = "honk"


/datum/data/pda/messenger_plugin/virus/mime
	icon = "arrow-circle-down"

/datum/data/pda/messenger_plugin/virus/mime/user_act(mob/user as mob, obj/item/device/pda/P)
	. = ..(user, P)
	if(.)
		user.show_message("<span class='notice'>Virus enviado!</span>", 1)
		var/datum/data/pda/app/M = P.find_program(/datum/data/pda/app/messenger)
		if(M)
			M.notify_silent = 1
		M = P.find_program(/datum/data/pda/app/chatroom)
		if(M)
			M.notify_silent = 1
		P.ttone = "silence"


/datum/data/pda/messenger_plugin/virus/detonate
	name = "*Detonar*"
	icon = "exclamation-circle"

/datum/data/pda/messenger_plugin/virus/detonate/user_act(mob/user as mob, obj/item/device/pda/P)
	. = ..(user, P)
	if(.)
		var/difficulty = 0

		if(pda.cartridge)
			difficulty += pda.cartridge.programs.len / 2
		else
			difficulty += 2

		if(!P.detonate || P.hidden_uplink)
			user.show_message("<span class='warning'>O PDA alvo não respode ao comando de detonar.</span>", 1)
			pda.cartridge.charges++
		else if(prob(difficulty * 12))
			user.show_message("<span class='warning'>Um erro apareceu para seu [pda].</span>", 1)
		else if(prob(difficulty * 3))
			user.show_message("<span class='danger'>A energia voultou para seu [pda]!</span>", 1)
			pda.close(user)
			pda.explode()
			log_admin("[key_name(user)] tentou explodir [P] com o cartucho Detonamix, mas falhou, você mesmo")
			message_admins("[key_name_admin(user)] tentou explodir [P] com o cartucho Detonamix, mas falhou, você mesmo", 1)
		else
			user.show_message("<span class='notice'>Successo!</span>", 1)
			log_admin("[key_name(user)] tentou explodir [P] com o cartucho Detonamix, e conseguiu")
			message_admins("[key_name_admin(user)] tentou explodir [P] com o cartucho Detonamix, e conseguiu", 1)
			P.explode()