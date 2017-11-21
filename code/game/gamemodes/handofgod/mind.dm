/datum/mind/proc/remove_hog_follower_prophet()
	ticker.mode.red_deity_followers -= src
	ticker.mode.red_deity_prophets -= src
	ticker.mode.blue_deity_prophets -= src
	ticker.mode.blue_deity_followers -= src
	ticker.mode.update_hog_icons_removed(src, "red")
	ticker.mode.update_hog_icons_removed(src, "blue")

/datum/mind/proc/make_Handofgod_follower(colour)
	. = 0
	switch(colour)
		if("red")
			//Remove old allegiances
			if(src in ticker.mode.blue_deity_followers || src in ticker.mode.blue_deity_prophets)
				to_chat(current, "<span class='danger'><B>You are no longer a member of the Blue cult!<B></span>")

			ticker.mode.blue_deity_followers -= src
			ticker.mode.blue_deity_prophets -= src
			current.faction |= "red god"
			current.faction -= "blue god"

			if(src in ticker.mode.red_deity_prophets)
				to_chat(current, "<span class='danger'><B>You have lost the connection with your deity, but you still believe in their grand design, You are no longer a prophet!</b></span>")
				ticker.mode.red_deity_prophets -= src

			ticker.mode.red_deity_followers |= src
			to_chat(current, "<span class='danger'><B>You are now a follower of the red cult's god!</b></span>")

			special_role = SPECIAL_ROLE_RED_FOLLOWER
			. = 1
		if("blue")
			//Remove old allegiances
			if(src in ticker.mode.red_deity_followers || src in ticker.mode.red_deity_prophets)
				to_chat(current, "<span class='danger'><B>You are no longer a member of the Red cult!<B></span>")

			ticker.mode.red_deity_followers -= src
			ticker.mode.red_deity_prophets -= src
			current.faction -= "red god"
			current.faction |= "blue god"

			if(src in ticker.mode.blue_deity_prophets)
				to_chat(current, "<span class='danger'><B>You have lost the connection with your deity, but you still believe in their grand design, You are no longer a prophet!</b></span>")
				ticker.mode.blue_deity_prophets -= src

			ticker.mode.blue_deity_followers |= src
			to_chat(current, "<span class='danger'><B>You are now a follower of the blue cult's god!</b></span>")

			special_role = SPECIAL_ROLE_BLUE_FOLLOWER
			. = 1
		else
			return 0

	ticker.mode.update_hog_icons_removed(src,"red")
	ticker.mode.update_hog_icons_removed(src,"blue")
	//ticker.mode.greet_hog_follower(src,colour)
	ticker.mode.update_hog_icons_added(src, colour)

/datum/mind/proc/make_Handofgod_prophet(colour)
	. = 0
	switch(colour)
		if("red")
			//Remove old allegiances

			if(src in ticker.mode.blue_deity_followers || src in ticker.mode.blue_deity_prophets)
				to_chat(current, "<span class='danger'><B>You are no longer a member of the Blue cult!<B></span>")
				current.faction -= "blue god"
			current.faction |= "red god"

			ticker.mode.blue_deity_followers -= src
			ticker.mode.blue_deity_prophets -= src
			ticker.mode.red_deity_followers -= src

			ticker.mode.red_deity_prophets |= src
			to_chat(current, "<span class='danger'><B>You are now a prophet of the red cult's god!</b></span>")

			special_role = SPECIAL_ROLE_RED_PROPHET
			. = 1
		if("blue")
			//Remove old allegiances

			if(src in ticker.mode.red_deity_followers || src in ticker.mode.red_deity_prophets)
				to_chat(current, "<span class='danger'><B>You are no longer a member of the Red cult!<B></span>")
				current.faction -= "red god"
			current.faction |= "blue god"

			ticker.mode.red_deity_followers -= src
			ticker.mode.red_deity_prophets -= src
			ticker.mode.blue_deity_followers -= src

			ticker.mode.blue_deity_prophets |= src
			to_chat(current, "<span class='danger'><B>You are now a prophet of the blue cult's god!</b></span>")

			special_role = SPECIAL_ROLE_BLUE_PROPHET
			. = 1

		else
			return 0

	ticker.mode.update_hog_icons_removed(src,"red")
	ticker.mode.update_hog_icons_removed(src,"blue")
	ticker.mode.greet_hog_follower(src,colour)
	ticker.mode.update_hog_icons_added(src, colour)


/datum/mind/proc/make_Handofgod_god(colour)
	switch(colour)
		if("red")
			current.become_god("red")
			ticker.mode.add_god(src,"red")
		if("blue")
			current.become_god("blue")
			ticker.mode.add_god(src,"blue")
		else
			return 0
	ticker.mode.forge_deity_objectives(src)
	ticker.mode.remove_hog_follower(src,0)
	ticker.mode.update_hog_icons_added(src, colour)
//	ticker.mode.greet_hog_follower(src,colour)
	return 1