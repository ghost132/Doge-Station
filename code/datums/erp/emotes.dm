/*
 *
 * EMOTE DECLARATION
 *
 */


/datum/forbidden/emote
	var/name

/datum/forbidden/emote/proc/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return

/datum/forbidden/emote/proc/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return -1

	//	return -1 = button doesn't appears on UI
	//	return 0 = disabled button
	//	return 1 = clickable button

/datum/forbidden/emote/proc/showText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	return

/datum/forbidden/emote/proc/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P, text = null)
	if(text)
		add_logs(P, H, text)

/datum/forbidden/emote/proc/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	return

/*
 *
 * EMOTES
 *
 */

// Kiss
/datum/forbidden/emote/kiss
	name = "kiss"

/datum/forbidden/emote/kiss/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Beijar [P.gender == FEMALE ? "seus" : "seus"] lábios"

/datum/forbidden/emote/kiss/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	if(get_dist(H, P) > 1)
		return -1
	if(H.incapacitated())
		return -1
	if(P == H)
		return -1
	if(!H.check_has_mouth() || !P.check_has_mouth())
		return -1

	if(!H.is_face_clean() || !P.is_face_clean())
		return 0

	return 1

/datum/forbidden/emote/kiss/showText(mob/living/carbon/human/H, mob/living/carbon/human/P)
	H.visible_message("<span class='erp'><b>[H]</b> beija <b>[P]</b>.</span>")

/datum/forbidden/emote/kiss/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "beijou")

/datum/forbidden/emote/kiss/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	H.pleasure += 1 * rand(0.9, 1.2)
	if(H.pleasure >= MAX_PLEASURE)
		H.cum(P, "floor")

	P.pleasure += 1 * rand(0.9, 1.2)
	if(P.pleasure >= MAX_PLEASURE)
		P.cum(H, "floor")
	..()


// Lick (tajaran kiss)
/datum/forbidden/emote/lick
	name = "lick"

/datum/forbidden/emote/lick/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Lamber [P.gender == FEMALE ? "seus" : "seus"] lábios"

/datum/forbidden/emote/lick/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	if(get_dist(H, P) > 1)
		return -1
	if(H.incapacitated())
		return -1
	if(P == H)
		return -1
	if(!H.check_has_mouth() || !P.check_has_mouth())
		return -1
	if(H.species.name != "Tajaran") // Only tajarans can lick other's lips
		return -1

	if(!H.is_face_clean() || !P.is_face_clean())
		return 0

	return 1

/datum/forbidden/emote/lick/showText(mob/living/carbon/human/H, mob/living/carbon/human/P)
	H.visible_message("<span class='erp'><b>[H]</b> lambe [P]'s lávios.</span>")

/datum/forbidden/emote/lick/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "licked")

/datum/forbidden/emote/lick/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	H.pleasure += 1 * rand(0.9, 1.2)
	if(H.pleasure >= MAX_PLEASURE)
		H.cum(P, "floor")

	P.pleasure += 1 * rand(0.9, 1.2)
	if(P.pleasure >= MAX_PLEASURE)
		P.cum(H, "floor")
	..()


// French Kiss
/datum/forbidden/emote/frenchkiss
	name = "french-kiss"

/datum/forbidden/emote/frenchkiss/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Dar para  [P.gender == FEMALE ? "ele" : "ela"] um beijo frances"

/datum/forbidden/emote/frenchkiss/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	if(get_dist(H, P) > 1)
		return -1
	if(H.incapacitated())
		return -1
	if(P == H)
		return -1
	if(!H.check_has_mouth() || !P.check_has_mouth())
		return -1

	if(!H.is_face_clean() || !P.is_face_clean())
		return 0

	return 1

/datum/forbidden/emote/frenchkiss/showText(mob/living/carbon/human/H, mob/living/carbon/human/P)
	H.visible_message("<span class='erp'><b>[H]</b> da para <b>[P]</b> um beijo frances.</span>")

/datum/forbidden/emote/frenchkiss/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "french-kissed")

/datum/forbidden/emote/frenchkiss/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	H.pleasure += 2 * rand(0.9, 1.2)
	if(H.pleasure >= MAX_PLEASURE)
		H.cum(P, "floor")

	P.pleasure += 2 * rand(0.9, 1.2)
	if(P.pleasure >= MAX_PLEASURE)
		P.cum(H, "floor")

	..()


// Cheek Kiss
/datum/forbidden/emote/cheekkiss
	name = "cheek-kiss"

/datum/forbidden/emote/cheekkiss/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Dar um beijo na bochecha para ele(a)"

/datum/forbidden/emote/cheekkiss/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	if(get_dist(H, P) > 1)
		return -1
	if(H.incapacitated())
		return -1
	if(P == H)
		return -1
	if(!H.check_has_mouth() || !P.check_has_mouth())
		return -1

	if(!H.is_face_clean() || !P.is_face_clean())
		return 0

	return 1

/datum/forbidden/emote/cheekkiss/showText(mob/living/carbon/human/H, mob/living/carbon/human/P)
	H.visible_message("<span class='erp'><b>[H]</b> da para <b>[P]</b> um beijo na bochecha.</span>")

/datum/forbidden/emote/cheekkiss/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "cheek-kissed")

/datum/forbidden/emote/cheekkiss/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..()


// Slap that ass!
/datum/forbidden/emote/assslap
	name = "ass-slap"

/datum/forbidden/emote/assslap/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Tapear sua bunda"

/datum/forbidden/emote/assslap/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	if(get_dist(H, P) > 1)
		return -1
	if(H.incapacitated())
		return -1
	if(P == H)
		return -1
	if(!H.has_hands() || !P.species.anus)
		return -1

	return 1

/datum/forbidden/emote/assslap/showText(mob/living/carbon/human/H, mob/living/carbon/human/P)
	H.visible_message("<span class='erp'><b>[H]</b> dá um tapa na bunda de [P].</span>")

/datum/forbidden/emote/assslap/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "ass-slapped")

/datum/forbidden/emote/assslap/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	playsound(H.loc, 'sound/effects/snap.ogg', 50, 1)
	..()


// Aquela sacaneada
/datum/forbidden/emote/boobgrab
	name = "boob-grab"

/datum/forbidden/emote/boobgrab/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	if(prob(1))
		return "Dar aquela sacaneada"

	return "Pegar nas peitolas"

/datum/forbidden/emote/boobgrab/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	if(get_dist(H, P) > 1)
		return -1
	if(H.incapacitated())
		return -1
	if(P == H)
		return -1
	if(!H.has_hands() || !P.has_vagina())
		return -1

	return 1

/datum/forbidden/emote/boobgrab/showText(mob/living/carbon/human/H, mob/living/carbon/human/P)
	H.visible_message("<span class='erp'><b>[H]</b> pega nos peitos de [P].</span>")

/datum/forbidden/emote/boobgrab/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "boob-grabbed")

/datum/forbidden/emote/boobgrab/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	P.pleasure += 1 * rand(0.9, 1.2)
	if(P.pleasure >= MAX_PLEASURE)
		P.cum(H, "floor")
	..()
