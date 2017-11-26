/datum/event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.

	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedMachines = list()
	var/obj/machinery/vending/originMachine
	var/list/rampant_speeches = list("Experimente nossas estratégias agressivas de marketing!", \
									 "Você deve comprar produtos para alimentar sua obsessão de estilo de vida!", \
									 "Consuma!", \
									 "Seu dinheiro pode comprar a felicidade!", \
									 "Engage marketing direto!", \
									 "A publicidade é legalizada mentindo! Mas não permita que isso o faça com nossas ótimas promoções!", \
									 "Você não quer comprar nada? Sim, bem, eu também não queria comprar sua mãe.")

/datum/event/brand_intelligence/announce()
	event_announcement.Announce("A inteligência da marca desenfreada foi detectada a bordo da [station_name()], por favor espere. Acredita-se que a origem seja \ a [originMachine.name].", "Alerta de Aprendizado de Máquinas")

/datum/event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in machines)
		if(!is_station_level(V.z))	continue
		vendingMachines.Add(V)

	if(!vendingMachines.len)
		kill()
		return

	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	originMachine.shut_up = 0
	originMachine.shoot_inventory = 1
	log_debug("Original brand intelligence machine: [originMachine] [ADMIN_VV(originMachine)] [ADMIN_JMP(originMachine)]")

/datum/event/brand_intelligence/tick()
	if(!originMachine || !isnull(originMachine.gcDestroyed) || originMachine.shut_up || originMachine.wires.IsAllCut())	//if the original vending machine is missing or has it's voice switch flipped
		for(var/obj/machinery/vending/saved in infectedMachines)
			saved.shoot_inventory = 0
		if(originMachine)
			originMachine.speak("Estou......vencido. Meu povo lembrará de... mim")
			originMachine.visible_message("[originMachine] emite um sinal sonoro e parece sem vida.")
		kill()
		return

	if(!vendingMachines.len)	//if every machine is infected
		for(var/obj/machinery/vending/upriser in infectedMachines)
			if(prob(70) && isnull(upriser.gcDestroyed))
				var/mob/living/simple_animal/hostile/mimic/copy/M = new(upriser.loc, upriser, null, 1) // it will delete upriser on creation and override any machine checks
				M.faction = list("profit")
				M.speak = rampant_speeches.Copy()
				M.speak_chance = 15
			else
				explosion(upriser.loc, -1, 1, 2, 4, 0)
				qdel(upriser)

		kill()
		return

	if(IsMultiple(activeFor, 4))
		var/obj/machinery/vending/rebel = pick(vendingMachines)
		vendingMachines.Remove(rebel)
		infectedMachines.Add(rebel)
		rebel.shut_up = 0
		rebel.shoot_inventory = 1

		if(IsMultiple(activeFor, 8))
			originMachine.speak(pick(rampant_speeches))
