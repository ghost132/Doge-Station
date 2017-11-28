/datum/event/anomaly/anomaly_vortex
	startWhen = 20
	announceWhen = 3
	endWhen = 80

/datum/event/anomaly/anomaly_vortex/announce()
	event_announcement.Announce("Anomalia de vortice de alta intensidade localizada detectada em scanners de longo alcance. Local esperado: [impact_area.name]", "Alerta de Anomalias")

/datum/event/anomaly/anomaly_vortex/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/bhole(T.loc)
