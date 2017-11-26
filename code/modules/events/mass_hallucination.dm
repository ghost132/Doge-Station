/datum/event/mass_hallucination/setup()
	announceWhen = rand(0, 20)

/datum/event/mass_hallucination/start()
	for(var/mob/living/carbon/human/H in living_mob_list)
		var/armor = H.getarmor(type = "rad")
		if((RADIMMUNE in H.species.species_traits) || armor >= 75) // Leave radiation-immune species/rad armored players completely unaffected
			continue
		H.AdjustHallucinate(rand(50, 100))

/datum/event/mass_hallucination/announce()
	event_announcement.Announce("Parece que a estação [station_name()] está passando por um campo de radição menor, isso pode causar alguma alucinação, mas nenhum dano adicional")
