/*
 *
 * ACTION DECLARATION
 *
 */
var/global/list/forbidden_actions = list()	// stores /datum/forbidden/action indexed by name

/datum/forbidden/action
	var/name
	var/HPleasure	// How much pleasure who is giving the action receive
	var/PPleasure	// How much pleasure who is receiving the action receive
					// This is a base, can be more or less

	var/HHole		// Used when who is giving the action cums
	var/PHole		// Used when who is receiving the action cums

/datum/forbidden/action/proc/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return

/datum/forbidden/action/proc/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	if(get_dist(H, P) > 1)
		return -1
	if(H.incapacitated(ignore_lying = TRUE))
		return -1
	return 1

	//	return -1 = button doesn't appears on UI
	//	return 0 = disabled button
	//	return 1 = clickable button

/datum/forbidden/action/proc/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	return

/datum/forbidden/action/proc/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P, text = null)
	if(!text)
		text = "fucked"
	add_logs(H, P, text)

/datum/forbidden/action/proc/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	H.do_fucking_animation(P)

	if(P != H)
		if(HPleasure)
			H.pleasure += HPleasure * rand(1, 1.4)
		if(PPleasure)
			P.pleasure += PPleasure * rand(1, 1.4)

		if(H.pleasure >= MAX_PLEASURE)
			H.cum(P, HHole ? HHole : "floor")
	else
		if(PPleasure)
			P.pleasure += PPleasure * rand(1, 1.4)

	if(P.pleasure >= MAX_PLEASURE)
		P.cum(H, PHole ? PHole : "floor")

/*
 *
 * ACTIONS
 *
 */


/*
 * ORAL ACTIONS
 */

/datum/forbidden/action/oral/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(H == P)
			. = -1
		else if(!H.check_has_mouth())
			. = -1
		else if(!H.is_face_clean())
			. = 0

// Cunnilingus
/datum/forbidden/action/oral/cunnilingus
	name = "cunnilingus"
	HPleasure = 3	// How much pleasure who is giving the action receive
	PPleasure = 4	// How much pleasure who is receiving the action receive

	HHole = "floor"
	PHole = "floor"

/datum/forbidden/action/oral/cunnilingus/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Lamba a vagina"

/datum/forbidden/action/oral/cunnilingus/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(!P.has_vagina())
			. = -1
		else if(!P.is_nude())
			. = 0

/datum/forbidden/action/oral/cunnilingus/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(begins)
		H.visible_message("<span class='erp'><b>[H]</b> começa a lamber <b>[P]</b>.</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> lambe <b>[P]</b>.</span>")

/datum/forbidden/action/oral/cunnilingus/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "cunnilinged")

/datum/forbidden/action/oral/cunnilingus/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	P.moan()
	..()


// Blowjob
/datum/forbidden/action/oral/blowjob
	name = "blowjob"
	HPleasure = 1	// How much pleasure who is giving the action receive
	PPleasure = 5	// How much pleasure who is receiving the action receive

	HHole = "floor"
	PHole = "mouth"

/datum/forbidden/action/oral/blowjob/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Chupar seu penis"

/datum/forbidden/action/oral/blowjob/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(!P.has_penis())
			. = -1
		else if(isfuck(P.lfaction))
			. = 0
		else if(isvagina(P.lfaction))
			. = 0
		else if(!P.is_nude())
			. = 0

/datum/forbidden/action/oral/blowjob/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(begins)
		H.visible_message("<span class='erp'><b>[H]</b> começa a chupar o penis de [P].</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> chupa o penis de [P].</span>")

/datum/forbidden/action/oral/blowjob/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "blowjobed")

/datum/forbidden/action/oral/blowjob/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	..()


// Tit suck
/datum/forbidden/action/oral/titsuck
	name = "tit-suck"
	HPleasure = 1	// How much pleasure who is giving the action receive
	PPleasure = 5	// How much pleasure who is receiving the action receive

	HHole = "floor"
	PHole = "floor"

/datum/forbidden/action/oral/titsuck/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Chupe suas tetas"

/datum/forbidden/action/oral/titsuck/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(!H.check_has_mouth() || !P.has_vagina())
			. = -1
		else if(!P.breast_nude())
			. = 0

/datum/forbidden/action/oral/titsuck/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(begins)
		H.visible_message("<span class='erp'><b>[H]</b> começa a chupar os peitos de [P]'.</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> chupa os peitos de [P].</span>")

/datum/forbidden/action/oral/titsuck/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "tit-sucked")

/datum/forbidden/action/oral/titsuck/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	..()


/*
 * FUCK ACTIONS
 */

/datum/forbidden/action/fuck/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(get_dist(H, P) >= 1)
			. = -1
		else if(H == P)
			. = -1
		else if(P.lastreceived != H && istype(P.lraction, type))
			. = -1

// Anal
/datum/forbidden/action/fuck/anal
	name = "anal"
	HPleasure = 6	// How much pleasure who is giving the action receive
	PPleasure = 6	// How much pleasure who is receiving the action receive

	HHole = "anus"
	PHole = "floor"

/datum/forbidden/action/fuck/anal/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Fuck [P.gender == FEMALE ? "her" : "his"] anus"

/datum/forbidden/action/fuck/anal/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(!P.species.anus || !H.has_penis())
			. = -1
		else if(!H.is_nude() || !P.is_nude())
			. = 0

/datum/forbidden/action/fuck/anal/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(begins)
		H.visible_message("<span class='erp'><b>[H]</b> começa a foder o anus de [P].</span>")
	else
		if(P.anal_virgin)
			H.visible_message("<span class='erp'><b>[H]</b> rasga o anus de [P] em pedaços.</span>")
		else
			H.visible_message("<span class='erp'><b>[H]</b> fode o anus de [P].</span>")

/datum/forbidden/action/fuck/anal/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "ass fucked")

/datum/forbidden/action/fuck/anal/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(P.anal_virgin && !begins)
		P.anal_virgin = 0
	P.moan()

	..()


// Vaginal
/datum/forbidden/action/fuck/vaginal
	name = "vaginal"
	HPleasure = 5	// How much pleasure who is giving the action receive
	PPleasure = 5	// How much pleasure who is receiving the action receive

	HHole = "vagina"
	PHole = "floor"

/datum/forbidden/action/fuck/vaginal/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Fuck her vagina"

/datum/forbidden/action/fuck/vaginal/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(!P.has_vagina() || !H.has_penis())
			. = -1
		else if(!H.is_nude() || !P.is_nude())
			. = 0
		else if(H.lastreceived != P && isvagina(H.lraction))
			. = 0
		else if(P.lastfucked != H && isvagina(P.lfaction))
			. = 0

/datum/forbidden/action/fuck/vaginal/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(begins)
		H.visible_message("<span class='erp'><b>[H]</b> começa a [pick("foder","penetrar")] <b>[P]</b>.</span>")
	else
		if(P.virgin)
			H.visible_message("<span class='erp'><b>[H]</b> rasga sem piedade o hymen de [P]!</span>")
		else
			H.visible_message("<span class='erp'><b>[H]</b> [pick("fode","penetra")] <b>[P]</b>.</span>")

/datum/forbidden/action/fuck/vaginal/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..()

/datum/forbidden/action/fuck/vaginal/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(P.virgin && !begins)
		P.emote("scream")
		if(prob(25))
			new /obj/effect/decal/cleanable/blood(P.loc)
		P.virgin = 0
	P.moan()

	..()


// Mouthfuck
/datum/forbidden/action/fuck/mouth
	name = "mouthfuck"
	HPleasure = 5	// How much pleasure who is giving the action receive
	PPleasure = 2	// How much pleasure who is receiving the action receive

	HHole = "mouth"
	PHole = "floor"

/datum/forbidden/action/fuck/mouth/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Fuck [P.gender == FEMALE ? "her" : "his"] mouth"

/datum/forbidden/action/fuck/mouth/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(!H.has_penis())
			. = -1
		else if(!P.is_face_clean() || !H.is_nude())
			. = 0
		else if(H.lastreceived != P && isvagina(H.lraction))
			. = 0
		else if(P.lastfucked != H && isoral(P.lfaction))
			. = 0

/datum/forbidden/action/fuck/mouth/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(begins)
		H.visible_message("<span class='erp'><b>[H]</b> começa a foder a boca de [P].</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> fode a boca de [P].</span>")

/datum/forbidden/action/fuck/mouth/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "mouth fucked")


/*
 * MISC ACTIONS
 */

/datum/forbidden/action/vagina/mount/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(get_dist(H, P) >= 1)
			. = -1
		else if(!H.has_vagina())
			. = -1
		else if(P.lastfucked != H && isfuck(P.lfaction))
			. = -1
		else if(H == P)
			. = -1

// Mount
/datum/forbidden/action/vagina/mount
	name = "mount"
	HPleasure = 5	// How much pleasure who is giving the action receive
	PPleasure = 5	// How much pleasure who is receiving the action receive

	HHole = "floor"
	PHole = "vagina"

/datum/forbidden/action/vagina/mount/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Mount on him"

/datum/forbidden/action/vagina/mount/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(!P.lying)
			. = 0
		else if(!H.is_nude() || !P.is_nude())
			. = 0

/datum/forbidden/action/vagina/mount/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(begins)
		H.visible_message("<span class='erp'><b>[H]</b> begins to mount on <b>[P]</b>.</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> mounts on <b>[P]</b>.</span>")

/datum/forbidden/action/vagina/mount/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "mounted")

/datum/forbidden/action/vagina/mount/doAction(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(H.virgin && !begins)
		H.emote("scream")
		if(prob(25))
			new /obj/effect/decal/cleanable/blood(P.loc)
		H.virgin = 0
	H.moan()

	..()

/datum/forbidden/action/fingering/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(get_dist(H, P) > 1)
			. = -1
		if(!H.has_hands())
			. = -1

// Vagina Fingering
/datum/forbidden/action/fingering/vagina
	name = "fingering"
	HPleasure = 0.4	// How much pleasure who is giving the action receive
	PPleasure = 2	// How much pleasure who is receiving the action receive

	HHole = "floor"
	PHole = "floor"

/datum/forbidden/action/fingering/vagina/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Finger [H == P ? "your" : "her"] vagina"

/datum/forbidden/action/fingering/vagina/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(!P.has_vagina())
			. = -1
		else if(!P.is_nude())
			. = 0

/datum/forbidden/action/fingering/vagina/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(H != P)
		if(begins)
			H.visible_message("<span class='erp'><b>[H]</b> começa a dedar <b>[P]</b>.</span>")
		else
			H.visible_message("<span class='erp'><b>[H]</b> deda <b>[P]</b>.</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> Deda sua vagina.</span>")

/datum/forbidden/action/fingering/vagina/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "vagina fingered")


// Ass Fingering
/datum/forbidden/action/fingering/anus
	name = "analfingering"
	HPleasure = 0.2	// How much pleasure who is giving the action receive
	PPleasure = 2	// How much pleasure who is receiving the action receive

	HHole = "floor"
	PHole = "floor"

/datum/forbidden/action/fingering/anus/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Finger [H == P ? "your" : P.gender == FEMALE ? "her" : "his"] anus"

/datum/forbidden/action/fingering/anus/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(!P.species.anus)
			. = -1
		else if(!P.is_nude())
			. = 0

/datum/forbidden/action/fingering/anus/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(H != P)
		if(begins)
			H.visible_message("<span class='erp'><b>[H]</b> começa a brincar com o anus de [P].</span>")
		else
			H.visible_message("<span class='erp'><b>[H]</b> brinca com o anus de [P].</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> brinca com seu anus.</span>")

/datum/forbidden/action/fingering/anus/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "ass fingered")


// Handjob
/datum/forbidden/action/handjob
	name = "handjob"
	HPleasure = 0.2	// How much pleasure who is giving the action receive
	PPleasure = 2	// How much pleasure who is receiving the action receive

	HHole = "floor"
	PHole = "floor"

/datum/forbidden/action/handjob/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "[H == P ? "Masturbe seu penis" : "Masturbe-o"]"

/datum/forbidden/action/handjob/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(get_dist(H, P) > 1)
			. = -1
		else if(isfuck(P.lfaction))
			. = -1
		else if(!P.has_penis() || !H.has_hands())
			. = -1
		else if(!P.is_nude())
			. = 0
		else if(isvagina(P.lraction))
			. = 0

/datum/forbidden/action/handjob/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(H != P)
		if(begins)
			H.visible_message("<span class='erp'><b>[H]</b> começa a masturbar o penis de <b>[P]</b>.</span>")
		else
			H.visible_message("<span class='erp'><b>[H]</b> masturba o penis de<b>[P]</b>.</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> se masturba.</span>")

/datum/forbidden/action/handjob/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "handjobed")


// Footjob
/datum/forbidden/action/footjob
	name = "footjob"
	HPleasure = 1	// How much pleasure who is giving the action receive
	PPleasure = 2	// How much pleasure who is receiving the action receive

	HHole = "floor"
	PHole = "floor"

/datum/forbidden/action/footjob/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Give him a footjob"

/datum/forbidden/action/footjob/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(get_dist(H, P) > 1)
			. = -1
		else if(H == P)
			. = -1
		else if(isfuck(P.lfaction))
			. = -1
		else if(!P.has_penis() || !H.has_foots())
			. = -1
		else if(!P.is_nude())
			. = 0
		else if(isvagina(P.lraction))
			. = 0

/datum/forbidden/action/footjob/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(begins)
		H.visible_message("<span class='erp'><b>[H]</b> começa a fazer footjob em <b>[P]</b>.</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> faz footjob em<b>[P]</b>.</span>")

/datum/forbidden/action/footjob/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "footjobed")


// Tribbing
/datum/forbidden/action/tribbing
	name = "tribbing"
	HPleasure = 4	// How much pleasure who is giving the action receive
	PPleasure = 4	// How much pleasure who is receiving the action receive

	HHole = "floor"
	PHole = "floor"

/datum/forbidden/action/tribbing/actionButton(mob/living/carbon/human/H, mob/living/carbon/human/P)
	return "Do scissoring"

/datum/forbidden/action/tribbing/conditions(mob/living/carbon/human/H, mob/living/carbon/human/P)
	. = ..(H, P)
	if(. != -1)
		if(get_dist(H, P) >= 1)
			. = -1
		else if(H == P)
			. = -1
		else if(!P.has_vagina() || !H.has_vagina())
			. = -1
		else if(!P.is_nude() || !H.is_nude())
			. = 0

/datum/forbidden/action/tribbing/fuckText(mob/living/carbon/human/H, mob/living/carbon/human/P, begins = 0)
	if(begins && !istype(P.lraction, type))
		H.visible_message("<span class='erp'><b>[H]</b> e <b>[P]</b> abremsuas pernas e coloca suas vaginas perto.</span>")
	else
		H.visible_message("<span class='erp'><b>[H]</b> esfrega sua vagina contra a vagina de [P].</span>")
/datum/forbidden/action/tribbing/logAction(mob/living/carbon/human/H, mob/living/carbon/human/P)
	..(H, P, "tribbed")
