//dollynho

/mob/living/simple_animal/zueiros/dollynho
	name = "Dollynho"
	desc = "Seu amiguinho."
	icon = 'icons/mob/mob.dmi'
	icon_state = "dollynho"
	icon_living = "dollynho"
	icon_resting = "dollynho"
	icon_dead = "dollynho"
	speak = list("Iae amiguinho?","Sou dollynho, seu amiguinho, vamos brincar?","Voce gosta de lolis?","Vamo ali atras amiguinho")
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

//HUE guy

/mob/living/simple_animal/zueiros/hue_guy
	name = "Hue Guy"
	desc = "HUEHUEHUE."
	icon = 'icons/mob/mob.dmi'
	icon_state = "hue_guy"
	icon_living = "hue_guy"
	icon_resting = "hue_guy"
	icon_dead = "hue_guy"
	speak = list("hue?","huehuehue","DESORDEM E HUE","Feijoada nada acontece")
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