#define MANIFEST_ERROR_CHANCE 5

/obj/item/weapon/paper/manifest
	name = "manifesto do suprimento"
	var/errors = 0
	var/points = 0
	var/ordernumber = 0

/obj/item/weapon/paper/manifest/New(atom/A, number, cost)
	..()
	ordernumber = number
	points = cost

	if(prob(MANIFEST_ERROR_CHANCE))
		errors |= MANIFEST_ERROR_COUNT
	if(prob(MANIFEST_ERROR_CHANCE))
		errors |= MANIFEST_ERROR_NAME
	if(prob(MANIFEST_ERROR_CHANCE))
		errors |= MANIFEST_ERROR_ITEM

/obj/item/weapon/paper/manifest/proc/is_approved()
	return stamped && stamped.len && !is_denied()

/obj/item/weapon/paper/manifest/proc/is_denied()
	return stamped && (/obj/item/weapon/stamp/denied in stamped)

/datum/supply_order
	var/ordernum
	var/orderer = null
	var/orderer_rank
	var/comment = null
	var/crates
	var/datum/supply_pack/pack = null

/datum/supply_order/New(datum/supply_pack/pack, orderer, orderer_rank, comment, crates)
	ordernum = shuttle_master.ordernum++
	src.pack = pack
	src.orderer = orderer
	src.orderer_rank = orderer_rank
	src.comment = comment
	src.crates = crates

/datum/supply_order/proc/generateRequisition(turf/T)
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(T)

	playsound(T, 'sound/goonstation/machines/printer_thermal.ogg', 50, 1)

	P.name = "Formulario de requisicao - [crates] '[pack.name]' para [orderer]"
	P.info += "<h3>[station_name] Formulario de Requisicao de Fornecimento</h3><hr>"
	P.info += "INDICE: #[shuttle_master.ordernum]<br>"
	P.info += "REQUERIDO POR: [orderer]<br>"
	P.info += "CATEGORIA: [orderer_rank]<br>"
	P.info += "MOTIVO: [comment]<br>"
	P.info += "TIPO DE SUPRIMENTO DA CAIXA: [pack.name]<br>"
	P.info += "NUMEROS DE CAIXA: [crates]<br>"
	P.info += "RESTRICAO DE ACESSO: [pack.access ? get_access_desc(pack.access) : "None"]<br>"
	P.info += "CONTEUDO:<br>"
	P.info += pack.printout()
	P.info += "<hr>"
	P.info += "SELO ABAIXO PARA APROVAR ESTA EXIGENCIA:<br>"

	P.update_icon()
	return P

/datum/supply_order/proc/generateManifest(obj/structure/closet/crate/C)
	var/obj/item/weapon/paper/manifest/P = new(C, ordernum, pack.cost)

	var/station_name = (P.errors & MANIFEST_ERROR_NAME) ? new_station_name() : station_name()
	var/packages_amount = shuttle_master.shoppinglist.len + ((P.errors & MANIFEST_ERROR_COUNT) ? rand(1,2) : 0)

	P.name = "Manifesto de Envio - '[pack.name]' for [orderer]"
	P.info = "<h3>[command_name()] Manifesto de Envio</h3><hr><br>"
	P.info += "Ordem: #[ordernum]<br>"
	P.info += "Destino: [station_name]<br>"
	P.info += "Requerido por: [orderer]<br>"
	P.info += "Categoria: [orderer_rank]<br>"
	P.info += "Motivo: [comment]<br>"
	P.info += "Tipo de Caixa de Suprimento: [pack.name]<br>"
	P.info += "Restricao de Acesso: [pack.access ? get_access_desc(pack.access) : "None"]<br>"
	P.info += "[packages_amount] PACOTES NESTA REMESSA<br>"
	P.info += "CONTEUDO:<br><ul>"
	for(var/atom/movable/AM in C.contents - P)
		if((P.errors & MANIFEST_ERROR_ITEM))
			if(prob(50))
				P.info += "<li>[AM.name]</li>"
			else
				continue
		P.info += "<li>[AM.name]</li>"
	//manifest finalisation
	P.info += "</ul><br>"
	P.info += "VERIFIQUE O INDICE E O SELO ABAIXO DA LINHA PARA CONFIRMAR O RECEBIMENTO D0S PRODUTOS<hr>" // And now this is actually meaningful.
	P.loc = C

	C.manifest = P
	C.announce_beacons = pack.announce_beacons.Copy()

	C.update_icon()
	P.update_icon()

	return P

/datum/supply_order/proc/generate(turf/T)
	var/obj/structure/closet/crate/C = pack.generate(T)
	var/obj/item/weapon/paper/manifest/M = generateManifest(C)

	if(M.errors & MANIFEST_ERROR_ITEM)
		if(istype(C, /obj/structure/closet/crate/secure) || istype(C, /obj/structure/closet/crate/large))
			M.errors &= ~MANIFEST_ERROR_ITEM
		else
			var/lost = max(round(C.contents.len / 10), 1)
			while(--lost >= 0)
				qdel(pick(C.contents))
	return C
