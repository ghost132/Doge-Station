/obj/item/device/pda/medical
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-médico"

/obj/item/device/pda/viro
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-virologista"

/obj/item/device/pda/engineering
	default_cartridge = /obj/item/weapon/cartridge/engineering
	icon_state = "pda-engenheiro"

/obj/item/device/pda/security
	default_cartridge = /obj/item/weapon/cartridge/security
	icon_state = "pda-segurança"

/obj/item/device/pda/detective
	default_cartridge = /obj/item/weapon/cartridge/detective
	icon_state = "pda-segurança"

/obj/item/device/pda/warden
	default_cartridge = /obj/item/weapon/cartridge/security
	icon_state = "pda-diretor"

/obj/item/device/pda/janitor
	default_cartridge = /obj/item/weapon/cartridge/janitor
	icon_state = "pda-zelador"
	ttone = "slip"

/obj/item/device/pda/toxins
	default_cartridge = /obj/item/weapon/cartridge/signal/toxins
	icon_state = "pda-cientista"
	ttone = "boom"

/obj/item/device/pda/clown
	default_cartridge = /obj/item/weapon/cartridge/clown
	icon_state = "pda-palhaço"
	desc = "Um micro computador portatil by Thinktronic Systems, LTD. A superfície é revestida com politetrafluoroetileno e cascas de banana."
	ttone = "honk"

	trip_stun = 8
	trip_weaken = 5
	trip_chance = 100
	trip_walksafe = TRUE
	trip_verb = TV_SLIP

/obj/item/device/pda/mime
	default_cartridge = /obj/item/weapon/cartridge/mime
	icon_state = "pda-mimico"
	ttone = "silence"

/obj/item/device/pda/mime/New()
	..()
	var/datum/data/pda/app/M = find_program(/datum/data/pda/app/messenger)
	if(M)
		M.notify_silent = 1
	M = find_program(/datum/data/pda/app/chatroom)
	if(M)
		M.notify_silent = 1

/obj/item/device/pda/heads
	default_cartridge = /obj/item/weapon/cartridge/head
	icon_state = "pda-h"

/obj/item/device/pda/heads/hop
	default_cartridge = /obj/item/weapon/cartridge/hop
	icon_state = "pda-hop"

/obj/item/device/pda/heads/hos
	default_cartridge = /obj/item/weapon/cartridge/hos
	icon_state = "pda-hos"

/obj/item/device/pda/heads/ce
	default_cartridge = /obj/item/weapon/cartridge/ce
	icon_state = "pda-ce"

/obj/item/device/pda/heads/cmo
	default_cartridge = /obj/item/weapon/cartridge/cmo
	icon_state = "pda-cmo"

/obj/item/device/pda/heads/rd
	default_cartridge = /obj/item/weapon/cartridge/rd
	icon_state = "pda-rd"

/obj/item/device/pda/captain
	default_cartridge = /obj/item/weapon/cartridge/captain
	icon_state = "pda-capitão"
	detonate = 0
	//toff = 1

/obj/item/device/pda/heads/ntrep
	default_cartridge = /obj/item/weapon/cartridge/supervisor
	icon_state = "pda-h"

/obj/item/device/pda/heads/magistrate
	default_cartridge = /obj/item/weapon/cartridge/supervisor
	icon_state = "pda-h"

/obj/item/device/pda/heads/blueshield
	default_cartridge = /obj/item/weapon/cartridge/hos
	icon_state = "pda-h"

/obj/item/device/pda/heads/ert

/obj/item/device/pda/heads/ert/engineering
	icon_state = "pda-engenheiro"

/obj/item/device/pda/heads/ert/security
	icon_state = "pda-segurança"

/obj/item/device/pda/heads/ert/medical
	icon_state = "pda-médico"


/obj/item/device/pda/cargo
	default_cartridge = /obj/item/weapon/cartridge/quartermaster
	icon_state = "pda-cargueiro"

/obj/item/device/pda/quartermaster
	default_cartridge = /obj/item/weapon/cartridge/quartermaster
	icon_state = "pda-superentedente"

/obj/item/device/pda/shaftminer
	icon_state = "pda-minerador"

/obj/item/device/pda/syndicate
	default_cartridge = /obj/item/weapon/cartridge/syndicate
	icon_state = "pda-syndi"
	name = "Military PDA"
	owner = "John Doe"

/obj/item/device/pda/syndicate/New()
	..()
	var/datum/data/pda/app/messenger/M = find_program(/datum/data/pda/app/messenger)
	if(M)
		M.m_hidden = 1

/obj/item/device/pda/chaplain
	icon_state = "pda-capelão"
	ttone = "holy"

/obj/item/device/pda/lawyer
	default_cartridge = /obj/item/weapon/cartridge/lawyer
	icon_state = "pda-advogado"
	ttone = "..."

/obj/item/device/pda/botanist
	//default_cartridge = /obj/item/weapon/cartridge/botanist
	icon_state = "pda-botanista"

/obj/item/device/pda/roboticist
	icon_state = "pda-roboticista"

/obj/item/device/pda/librarian
	icon_state = "pda-bibliotecario"
	desc = "Um micro computador portatil by Thinktronic Systems, LTD. Este modelo é um WRw-11 e-reader sério."
	model_name = "Thinktronic 5290 WGW-11 Series E-reader and Personal Data Assistant"

/obj/item/device/pda/librarian/New()
	..()
	var/datum/data/pda/app/M = find_program(/datum/data/pda/app/messenger)
	if(M)
		M.notify_silent = 1 //Quiet in the library!
	M = find_program(/datum/data/pda/app/chatroom)
	if(M)
		M.notify_silent = 1 //Quiet in the library!

/obj/item/device/pda/clear
	icon_state = "pda-transparente"
	desc = "Um micro computador portatil by Thinktronic Systems, LTD. Este é um modelo de edição especial com case tranparente (tipo iphone gold)."
	model_name = "Thinktronic 5230 Personal Data Assistant Deluxe Special Max Turbo Limited Edition"

/obj/item/device/pda/chef
	icon_state = "pda-chef"

/obj/item/device/pda/bar
	icon_state = "pda-bartender"

/obj/item/device/pda/atmos
	default_cartridge = /obj/item/weapon/cartridge/atmos
	icon_state = "pda-atmos"

/obj/item/device/pda/chemist
	default_cartridge = /obj/item/weapon/cartridge/chemistry
	icon_state = "pda-quimico"

/obj/item/device/pda/geneticist
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-geneticista"

/obj/item/device/pda/centcom
	default_cartridge = /obj/item/weapon/cartridge/centcom
	icon_state = "pda-h"

//Some spare PDAs in a box
/obj/item/weapon/storage/box/PDAs
	name = "PDAs dispenssados"
	desc = "Uma caixa com PDAs dispenssados."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdabox"

/obj/item/weapon/storage/box/PDAs/New()
		..()
		new /obj/item/device/pda(src)
		new /obj/item/device/pda(src)
		new /obj/item/device/pda(src)
		new /obj/item/device/pda(src)
		new /obj/item/weapon/cartridge/head(src)

		var/newcart = pick(	/obj/item/weapon/cartridge/engineering,
							/obj/item/weapon/cartridge/security,
							/obj/item/weapon/cartridge/medical,
							/obj/item/weapon/cartridge/signal/toxins,
							/obj/item/weapon/cartridge/quartermaster)
		new newcart(src)
