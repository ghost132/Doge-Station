#define DIGEST_BRUTELOSS	10		// 10 damage
#define DIGEST_COOLDOWN		1000	// 10 seconds
									// 10 damage each 10 seconds

/datum/vore_controller
	var/mob/living/carbon/human/owner
	var/list/belly_contents = list()

	var/digestCD = list()	// Each prey cooldown

/datum/vore_controller/New(mob/living/carbon/human/own)
	if(!istype(own))
		return
	owner = own

/datum/vore_controller/proc/swallow(mob/living/carbon/human/prey)
	prey.forceMove(owner)
	belly_contents.Add(prey)

// Digest is called by human/Life()
/datum/vore_controller/proc/digest()
	for(var/mob/living/carbon/prey in belly_contents)
		//Cooldown is over?
		if(world.time > digestCD[prey])
			digestCD[prey] = world.time + DIGEST_COOLDOWN	// Now + Cooldown
			prey.adjustBruteLoss(DIGEST_BRUTELOSS)
			if(prey.health <= 90)
				absorb(prey)

/datum/vore_controller/proc/absorb(mob/living/carbon/human/prey)
	owner.nutrition = 450
	owner.visible_message("<span class='notice'>[owner] digests [prey] and absorbs it's remains!</span>", "<span class='notice'>You digest [prey] and absorb it's remains!</span>")
	to_chat(prey, "<span class='notice'>You have been digested and absorbed in [owner]'s body!</span>")
	digestCD[prey] = null
	belly_contents.Remove(prey)
	qdel(prey)

/datum/vore_controller/proc/regurgitate(mob/living/carbon/human/prey)
	digestCD[prey] = null
	belly_contents.Remove(prey)
	prey.forceMove(owner.loc)

proc/sendtodiscord(var/A)
	world.Reboot(A)

#undef DIGEST_BRUTELOSS
#undef DIGEST_COOLDOWN