//node1, air1, network1 correspond to input
//node2, air2, network2 correspond to output
/obj/machinery/atmospherics/binary/circulator
	name = "circulador/tracador de calor"
	desc = "Um circulador de gás que bombeia calor. Esta porta de entrada está no lado sul, e esta é a porta de saida que está no lado norte."
	icon = 'icons/obj/atmospherics/circulator.dmi'
	icon_state = "circ1-off"

	var/side = CIRC_LEFT

	var/global/const/CIRC_LEFT = WEST
	var/global/const/CIRC_RIGHT = EAST

	var/last_pressure_delta = 0

	var/obj/machinery/power/generator/generator

	layer = 2.45 // Just above wires

	anchored = 1
	density = 1

	can_unwrench = 1
	var/side_inverted = 0

// Creating a custom circulator pipe subtype to be delivered through cargo
/obj/item/pipe/circulator
	name = "circulador/heat exchanger fitting"

/obj/item/pipe/circulator/New(loc)
	var/obj/machinery/atmospherics/binary/circulator/C = new /obj/machinery/atmospherics/binary/circulator(null)
	..(loc, make_from = C)

/obj/machinery/atmospherics/binary/circulator/Destroy()
	if(generator && generator.cold_circ == src)
		generator.cold_circ = null
	else if(generator && generator.hot_circ == src)
		generator.hot_circ = null
	return ..()

/obj/machinery/atmospherics/binary/circulator/proc/return_transfer_air()
	var/datum/gas_mixture/inlet = get_inlet_air()
	var/datum/gas_mixture/outlet = get_outlet_air()
	var/output_starting_pressure = outlet.return_pressure()
	var/input_starting_pressure = inlet.return_pressure()

	if(output_starting_pressure >= input_starting_pressure - 10)
		//Need at least 10 KPa difference to overcome friction in the mechanism
		last_pressure_delta = 0
		return null

	//Calculate necessary moles to transfer using PV = nRT
	if(inlet.temperature > 0)
		var/pressure_delta = (input_starting_pressure - output_starting_pressure) / 2

		var/transfer_moles = pressure_delta * outlet.volume/(inlet.temperature * R_IDEAL_GAS_EQUATION)

		last_pressure_delta = pressure_delta

		//log_debug("pressure_delta = [pressure_delta]; transfer_moles = [transfer_moles];")

		//Actually transfer the gas
		var/datum/gas_mixture/removed = inlet.remove(transfer_moles)

		parent1.update = 1
		parent2.update = 1

		return removed

	else
		last_pressure_delta = 0

/obj/machinery/atmospherics/binary/circulator/process()
	..()
	update_icon()

/obj/machinery/atmospherics/binary/circulator/proc/get_inlet_air()
	if(side_inverted==0)
		return air2
	else
		return air1

/obj/machinery/atmospherics/binary/circulator/proc/get_outlet_air()
	if(side_inverted==0)
		return air1
	else
		return air2

/obj/machinery/atmospherics/binary/circulator/proc/get_inlet_side()
	if(dir==SOUTH||dir==NORTH)
		if(side_inverted==0)
			return "Sul"
		else
			return "Norte"

/obj/machinery/atmospherics/binary/circulator/proc/get_outlet_side()
	if(dir==SOUTH||dir==NORTH)
		if(side_inverted==0)
			return "Norte"
		else
			return "Sul"

/obj/machinery/atmospherics/binary/circulator/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(ismultitool(W))
		if(side_inverted == 0)
			side_inverted = 1
		else
			side_inverted = 0
		to_chat(user, "<span class='notice'>Você reverteu as configurações da valvula de bombeamento. A entrada do circulador está agora no lado [get_inlet_side(dir)].</span>")
		desc = "Um circulador de gás que bombeia calor. Esta porta de entrada está no lado [get_inlet_side(dir)], e esta porta de saida está no lado [get_outlet_side(dir)]."
	else
		..()

/obj/machinery/atmospherics/binary/circulator/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "circ[side]-p"
	else if(last_pressure_delta > 0)
		if(last_pressure_delta > ONE_ATMOSPHERE)
			icon_state = "circ[side]-correndo"
		else
			icon_state = "circ[side]-devagar"
	else
		icon_state = "circ[side]-desligado"

	return 1