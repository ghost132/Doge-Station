/datum/event/anomaly/anomaly_pyro
	startWhen = 30
	announceWhen = 3
	endWhen = 110

/datum/event/anomaly/anomaly_pyro/announce()
	event_announcement.Announce("Anomalia atmosferica detectada em scanners de longo alcance. Local esperado: [impact_area.name].", "Alerta de Anomalias")

/datum/event/anomaly/anomaly_pyro/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/pyro(T.loc)

/datum/event/anomaly/anomaly_pyro/tick()
	if(!newAnomaly)
		kill()
		return
	if(IsMultiple(activeFor, 5))
		newAnomaly.anomalyEffect()

/datum/event/anomaly/anomaly_pyro/end()
	if(newAnomaly.loc)
		explosion(get_turf(newAnomaly), -1,0,3, flame_range = 4)

		var/mob/living/carbon/slime/S = new/mob/living/carbon/slime(get_turf(newAnomaly))
		S.colour = pick("red", "orange")

		qdel(newAnomaly)
