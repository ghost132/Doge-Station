/datum/event/meteor_wave
	startWhen		= 5
	endWhen 		= 7
	var/next_meteor = 6
	var/waves = 1

/datum/event/meteor_wave/setup()
	waves = severity * rand(1,3)

/datum/event/meteor_wave/announce()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			event_announcement.Announce("Meteoros foram detectados em rota de colisão com a estação.", "Alerta de Meteoro.", new_sound = 'sound/AI/meteors.ogg')
		else
			event_announcement.Announce("A estação está agora em uma chuva de meteoros.", "Alerta de Meteoro.")

//meteor showers are lighter and more common,
/datum/event/meteor_wave/tick()
	if(waves && activeFor >= next_meteor)
		spawn() spawn_meteors(severity * rand(1,2), get_meteors())
		next_meteor += rand(15, 30) / severity
		waves--
		endWhen = (waves ? next_meteor + 1 : activeFor + 15)

/datum/event/meteor_wave/end()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			event_announcement.Announce("A estação limpou a tempestade de meteoros.", "Alerta de Meteoro.")
		else
			event_announcement.Announce("A estação limpou a chuva de meteoros", "Alerta de Meteoro.")

/datum/event/meteor_wave/proc/get_meteors()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			return meteors_catastrophic
		if(EVENT_LEVEL_MODERATE)
			return meteors_threatening
		else
			return meteors_normal
