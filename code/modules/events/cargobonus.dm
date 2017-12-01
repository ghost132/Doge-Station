/datum/event/cargo_bonus
	announceWhen	= 5

/datum/event/cargo_bonus/announce()
	event_announcement.Announce("Parabens! [station_name()] foi escolhido para um aumento de limite de suprimento. Entre em contato com o departamento de carga local para obter detalhes!", "Alerta de Oferta")

/datum/event/cargo_bonus/start()
	supply_controller.points += rand(100,500)
