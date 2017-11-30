//annoying dog

/mob/living/simple_animal/annoying_dog
	name = "annoying dog"
	desc = "AU AU!."
	icon = 'icons/mob/annoying_dog.dmi'
	icon_state = "annoying_dog"
	icon_living = "annoying_dog"
	icon_resting = "annoying_sleep"
	icon_dead = "annoying_dead"
	speak = list("au?","au","AU","Teu cu")
	speak_emote = list("barks")
	emote_hear = list("barks")
	emote_see = list("rolls around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/ham = 6)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 50
	maxHealth = 50
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY
	blood_volume = BLOOD_VOLUME_NORMAL