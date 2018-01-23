/mob/living/simple_animal/hostile/galina_assassina
	name = "galinha assassina"
	desc = "Come o cu de curioso que entra em lugar improrpio."
	icon_state = "chicken_brown"
	icon_living = "chicken_brown"
	icon_dead = "chicken_dead"
	icon_gib = "chicken_gib"
	speak = list("To comendo cu de curioso")
	speak_emote = list("clucks","croons")
	emote_hear = list("estranhamente fala")
	emote_see = list("ataca ferozmente")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 2)
	var/egg_type = /obj/item/weapon/reagent_containers/food/snacks/egg
	var/food_type = /obj/item/weapon/reagent_containers/food/snacks/grown/wheat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	stop_automated_movement_when_pulled = 0
	maxHealth = 600
	health = 600
	melee_damage_lower = 20
	melee_damage_upper = 30
	attacktext = "pica ferozmente"
	friendly = "olha o cu do curioso"
	mob_size = MOB_SIZE_SMALL