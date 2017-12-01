/datum/event/meteor_wave/gore/announce()
		event_announcement.Announce("Detritos biologicos desconhecidos foram detectados perto de [station_name()], por favor aguarde.", "Alerta de Detritos")

/datum/event/meteor_wave/gore/setup()
	waves = 3


/datum/event/meteor_wave/gore/tick()
	if(waves && activeFor >= next_meteor)
		spawn() spawn_meteors(rand(5,8), meteors_gore)
		next_meteor += rand(15, 30)
		waves--
		endWhen = (waves ? next_meteor + 1 : activeFor + 15)


/datum/event/meteor_wave/gore/end()
	event_announcement.Announce("A estacao limpou os detritos.", "Alerta de Detritos")
