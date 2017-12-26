turf
	portal_one
		name = "Background"
		icon = 'icons/turf/teste/turf.dmi'
		icon_state = "portal_one"
		Enter() // when you step on it the portal it teleports you to the next exact turf.
			usr.loc = locate(/turf/portal_two)
			usr << "You have been transferred into a new zone."

	portal_two
		name = "Background_2"
		icon = 'icons/turf/teste/turf.dmi'
		icon_state = "portal_two"
		Enter() // when you step on it the portal it teleports you to the next exact turf.
			usr.loc = locate(/turf/portal_one)
			usr << "You have been transferred into a new zone."