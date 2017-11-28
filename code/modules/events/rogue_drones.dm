/datum/event/rogue_drone
	startWhen = 10
	endWhen = 1000
	var/list/drones_list = list()

/datum/event/rogue_drone/start()
	//spawn them at the same place as carp
	var/list/possible_spawns = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			possible_spawns.Add(C)

	//25% chance for this to be a false alarm
	var/num
	if(prob(25))
		num = 0
	else
		num = rand(2,6)
	for(var/i=0, i<num, i++)
		var/mob/living/simple_animal/hostile/retaliate/malf_drone/D = new(get_turf(pick(possible_spawns)))
		drones_list.Add(D)
		if(prob(25))
			D.disabled = rand(15, 60)

/datum/event/rogue_drone/announce()
	var/msg
	if(prob(33))
		msg = "Uma ala de drone de combate que opera fora do NSV Icarus nao conseguiu retornar de uma varredura deste setor, se houver alguma abordagem avistada com cautela."
	else if(prob(50))
		msg = "O contato foi perdido com uma ala de drone de combate que opera fora do NSV Icarus. Se alguem estiver avistado na area, se aproximar com cautela."
	else
		msg = "Os hackers nao identificados visaram uma ala de drone de combate implantada do NSV Icarus. Se alguem estiver avistado na area, se aproximar com cautela."
	event_announcement.Announce(msg, "Alerta de Drone Rogue")

/datum/event/rogue_drone/tick()
	return

/datum/event/rogue_drone/end()
	var/num_recovered = 0
	for(var/mob/living/simple_animal/hostile/retaliate/malf_drone/D in drones_list)
		var/datum/effect/system/spark_spread/sparks = new /datum/effect/system/spark_spread()
		sparks.set_up(3, 0, D.loc)
		sparks.start()
		D.z = level_name_to_num(CENTCOMM)
		D.has_loot = 0

		qdel(D)
		num_recovered++

	if(num_recovered > drones_list.len * 0.75)
		event_announcement.Announce("O controle do drone Icarus informa que a asa incorreta foi recuperada com seguranca.", "Alerta de Drone Rogue")
	else
		event_announcement.Announce("O controle do drone de Icarus decepciona a perda dos drones, mas os sobreviventes foram recuperados.", "Alerta de Drone Rogue")
