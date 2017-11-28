/datum/event/meteor_wave/goreop/announce()
	var/meteor_declaration = "Os MeteorosOps declararam sua intenção de destruir completamente [station_name()] com seus próprios corpos, e se atreve à tripulação para tentar detê-los."
	event_announcement.Announce(meteor_declaration, "Declaração de 'Guerra'", 'sound/effects/siren.ogg')

/datum/event/meteor_wave/goreop/setup()
	waves = 3


/datum/event/meteor_wave/goreop/tick()
	if(waves && activeFor >= next_meteor)
		spawn() spawn_meteors(5, meteors_ops)
		next_meteor += rand(15, 30)
		waves--
		endWhen = (waves ? next_meteor + 1 : activeFor + 15)



/datum/event/meteor_wave/goreop/end()
	event_announcement.Announce("Todos os Meteoros estao mortos. Major Station Victory.", "MeteorosOps")
