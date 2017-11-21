/mob/living/simple_animal/goose
	name = "goose"
	real_name = "goose"
	desc = "It's a goose!"
	icon_state = "goose_normal"
	icon_living = "goose_normal"
	icon_dead = "goose_normal_dead"
	speak = list("fuck this shit")
	speak_emote = list("flaps")
	emote_hear = list("flaps")
	emote_see = list("flaps")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 20
	health = 20
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 2)
	response_help  = "flaps"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	density = 1
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	var/goose_type //This variable is useless
	layer = MOB_LAYER
	atmos_requirements = list("min_oxy" = 16, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = 0
	can_collar = 0
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY


/mob/living/simple_animal/goose/Life()
	. = ..()
	if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			stat = CONSCIOUS
			icon_state = "goose_[goose_type]"
			wander = 1
		else if(prob(5))
			emote("snuffles")


/mob/living/simple_animal/goose/clown
	name = "Gonk"
	desc = "Says the legends that goose ate a bicycle horn, this explains why it is so annoying."
	icon_state = "goose_clown"
	icon_living = "goose_clown"
	icon_dead = "goose_clown_dead"
	goose_type = "clown" //Daughter of an useless variable
	response_help = "honks"
	response_disarm = "gently pushes aside"
	response_harm   = "splats"
	gold_core_spawnable = CHEM_MOB_SPAWN_INVALID
	speak = list("Honk!","HONK!","Honk?")
	speak_emote = list("honks")
	emote_hear = list("honks")
	emote_see = list("runs in a honk", "honks", "honks at something")
	var/turns_since_scan = 0
	var/obj/movement_target
	var/honktime = 0

/mob/living/simple_animal/goose/clown/verb/Honk()
	set name = "Honk"
	set category = "IC"
	set desc = "HONK!"

	if(honktime > world.time)
		return
	honktime = world.time + 30
	playsound(src, 'sound/items/bikehorn.ogg', 100, 1)
	custom_emote(1, pick("honks.","honks!"))

/mob/living/simple_animal/goose/clown/death()
	desc = "HONK is dead."
	..()

/mob/living/simple_animal/goose/clown/handle_automated_speech()
	..()
	if(prob(speak_chance))
		for(var/mob/M in view())
			custom_emote(1, pick("honks.","honks!"))
			M << 'sound/items/bikehorn.ogg'

/mob/living/simple_animal/goose/clown/process_ai()
	..()

	//Feeding, chasing food, FOOOOODDDD
	if(!resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/obj/item/weapon/reagent_containers/food/snacks/grown/banana/B in oview(src,3))
					if(isturf(B.loc) || ishuman(B.loc))
						movement_target = B
						break
			if(movement_target)
				spawn(0)
					stop_automated_movement = 1
					step_to(src,movement_target,1)
					sleep(3)
					step_to(src,movement_target,1)
					sleep(3)
					step_to(src,movement_target,1)

					if(movement_target)		//Not redundant due to sleeps, Item can be gone in 6 decisecomds
						if (movement_target.loc.x < src.x)
							dir = WEST
						else if (movement_target.loc.x > src.x)
							dir = EAST
						else if (movement_target.loc.y < src.y)
							dir = SOUTH
						else if (movement_target.loc.y > src.y)
							dir = NORTH
						else
							dir = SOUTH

						if(!Adjacent(movement_target)) //can't reach food through windows.
							return

						if(isturf(movement_target.loc) )
							movement_target.attack_animal(src)
						else if(ishuman(movement_target.loc) )
							if(prob(20))
								custom_emote(1, "stares at [movement_target.loc]'s [movement_target] with a sad puppy-face")

		if(prob(1))
			custom_emote(1, pick("honks.","honks!"))
			for(var/mob/M in view())
				M << 'sound/items/bikehorn.ogg'
