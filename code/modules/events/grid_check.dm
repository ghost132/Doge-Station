/datum/event/grid_check	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 5

/datum/event/grid_check/setup()
	endWhen = rand(30,120)

/datum/event/grid_check/start()
	power_failure(0)

/datum/event/grid_check/announce()
	event_announcement.Announce("Atividade anormal detectada na rede de energia na [station_name()]. Como medida de precaucao, a energia da estacao sera desligado por um periodo indefinido.", "Verificacao de grade automatizada", new_sound = 'sound/AI/poweroff.ogg')

/datum/event/grid_check/end()
	power_restore()

/proc/power_failure(var/announce = 1)
	if(announce)
		event_announcement.Announce("Atividade anormal detectada na rede de energia na [station_name()]. Como medida de precaucao, a energia da estacao sera desligado por um periodo indefinido. ", "Falha de energia critica", new_sound = 'sound/AI/poweroff.ogg')

	var/list/skipped_areas = list(/area/turret_protected/ai)
	var/list/skipped_areas_apc = list(/area/engine/engineering)

	for(var/obj/machinery/power/smes/S in machines)
		var/area/current_area = get_area(S)
		if(current_area.type in skipped_areas || !is_station_level(S.z))
			continue
		S.last_charge			= S.charge
		S.last_output_attempt	= S.output_attempt
		S.last_input_attempt 	= S.input_attempt
		S.charge = 0
		S.inputting(0)
		S.outputting(0)
		S.update_icon()
		S.power_change()

	for(var/obj/machinery/power/apc/C in apcs)
		var/area/current_area = get_area(C)
		if(current_area.type in skipped_areas_apc || !is_station_level(C.z))
			continue
		if(C.cell)
			C.cell.charge = 0

/proc/power_restore(var/announce = 1)
	var/list/skipped_areas = list(/area/turret_protected/ai)
	var/list/skipped_areas_apc = list(/area/engine/engineering)

	if(announce)
		event_announcement.Announce("A energia foi restaurado para [station_name()]. Pedimos desculpas pela inconveniencia.", "Sistema de energia nominal", new_sound = 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/apc/C in apcs)
		var/area/current_area = get_area(C)
		if(current_area.type in skipped_areas_apc || !is_station_level(C.z))
			continue
		if(C.cell)
			C.cell.charge = C.cell.maxcharge
	for(var/obj/machinery/power/smes/S in machines)
		var/area/current_area = get_area(S)
		if(current_area.type in skipped_areas || !is_station_level(S.z))
			continue
		S.charge = S.last_charge
		S.output_attempt = S.last_output_attempt
		S.input_attempt = S.last_input_attempt
		S.update_icon()
		S.power_change()

/proc/power_restore_quick(var/announce = 1)
	if(announce)
		event_announcement.Announce("Todos os SMES na [station_name()] foram recarregados. Pedimos desculpas pela incoveniencia.", "Sistema de energia nominal", new_sound = 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/smes/S in machines)
		if(!is_station_level(S.z))
			continue
		S.charge = S.capacity
		S.output_level = S.output_level_max
		S.output_attempt = 1
		S.input_attempt = 1
		S.update_icon()
		S.power_change()
