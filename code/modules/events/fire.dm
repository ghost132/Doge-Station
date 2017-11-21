/*
 *
 * FIRE!
 *
 */

/datum/event/fire


/*
 *
 * Gas leak fire
 *
 */
/datum/event/fire/gas_leak
	var/obj/machinery/portable_atmospherics/canister/selectedCanister
	var/list/area/selectableAreas

/datum/event/fire/gas_leak/setup(loop=0)
	var/safety_loop = loop + 1
	if(safety_loop > 25)
		kill()
		end()
		return

	findCanister()

	if(!selectedCanister)
		setup(safety_loop)

/datum/event/fire/gas_leak/start()
	var/turf/simulated/T = selectedCanister.loc
	var/temperature = selectedCanister.air_contents.temperature
	selectedCanister.health = 0
	selectedCanister.healthcheck()
	T.hotspot_expose((temperature*2) + 380,500)

/datum/event/fire/gas_leak/proc/findCanister()
	if(!selectableAreas)
		for(var/area/areapath in list(/area/toxins/storage, /area/atmos))
			selectableAreas += typesof(areapath)

	for(var/area/imp_area in selectableAreas)
		for(var/obj/machinery/portable_atmospherics/canister/can in imp_area)
			if(istype(can.loc, /turf/simulated))
				if(can.air_contents.toxins)
					selectedCanister = can
					return
		selectableAreas -= imp_area

/*
 *
 * Electric fire
 *
 */
/datum/event/fire/electric
	var/obj/structure/cable/selectedCable
	var/turf/simulated/T

/datum/event/fire/electric/setup(loop=0)
	var/safety_loop = loop + 1
	if(safety_loop > 25)
		kill()
		end()
		return

	findCable()

	if(!selectedCable)
		setup(safety_loop)

/datum/event/fire/electric/tick()
	if(prob(1))
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(5, 1, selectedCable)
		s.start()

	T.hotspot_expose((rand(200, 500)*2) + 380,500)

/datum/event/fire/electric/proc/findCable()
	for(var/obj/structure/cable/cab in cable_list)
		if(istype(cab.loc, /turf/simulated) && !cab.invisibility && cab.powernet && cab.powernet.avail > 0)
			T = cab.loc
			selectedCable = cab
			return


/*
 *
 * Wood fire
 *
 */
/datum/event/fire/wood
	var/obj/selectedObj
	var/list/area/selectableAreas

/datum/event/fire/wood/setup(loop=0)
	var/safety_loop = loop + 1
	if(safety_loop > 25)
		kill()
		end()
		return

	findObject()

	if(!selectedObj)
		setup(safety_loop)

/datum/event/fire/wood/start()
	selectedObj.fire_act()

/datum/event/fire/wood/proc/findObject()
	if(!selectableAreas)
		for(var/area/areapath in list(/area/bridge/meeting_room, /area/crew_quarters, /area/medical/psych, /area/library, /area/chapel/main, /area/chapel/office, /area/ntrep, /area/blueshield, /area/civilian/pet_store, /area/security/vacantoffice, /area/clownoffice, /area/mimeoffice, /area/magistrateoffice, /area/security/detectives_office))
			selectableAreas += typesof(areapath)

	for(var/area/imp_area in selectableAreas)
		for(var/obj/O in imp_area)
			if(O.burn_state == FLAMMABLE)
				selectedObj = O
				return
		selectableAreas -= imp_area