/obj/item/device/export_scanner
	name = "scanner de exportacao"
	desc = "Um dispositivo usado para verificar objetos contra o banco de dados de exportacoes da Nanotrasen."
	icon_state = "export_scanner"
	item_state = "radio"
	flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	siemens_coefficient = 1
	var/obj/machinery/computer/supplycomp/cargo_console = null

/obj/item/device/export_scanner/examine(user)
	..()
	if(!cargo_console)
		to_chat(user, "<span class='notice'>O [src] atualmente nao esta vinculado a um console de carga.</span>")

/obj/item/device/export_scanner/afterattack(obj/O, mob/user, proximity)
	if(!istype(O) || !proximity)
		return

	if(istype(O, /obj/machinery/computer/supplycomp))
		var/obj/machinery/computer/supplycomp/C = O
		cargo_console = C
		to_chat(user, "<span class='notice'>Scanner ligado a [C].</span>")
	else if(!istype(cargo_console))
		to_chat(user, "<span class='warning'>Voce deve vincular [src] para um console de carga primeiro!</span>")
	else
		// Before you fix it:
		// yes, checking manifests is a part of intended functionality.
		var/price = export_item_and_contents(O, cargo_console.contraband, cargo_console.emagged, dry_run=TRUE)

		if(price)
			to_chat(user, "<span class='notice'>Escaneado [O], valor: <b>[price]</b> creditos[O.contents.len ? " (contents included)" : ""].</span>")
		else
			to_chat(user, "<span class='warning'>Escaneado [O], sem valor de exportacao.</span>")
