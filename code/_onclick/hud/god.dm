
/datum/hud/hog_god/New(mob/owner)
	..()
	healths = new /obj/screen/healths/deity()
	infodisplay += healths

	deity_power_display = new /obj/screen/deity_power_display()
	infodisplay += deity_power_display

	deity_follower_display = new /obj/screen/deity_follower_display()
	infodisplay += deity_follower_display


/obj/screen/deity_power_display
	name = "Faith"
	icon_state = "deity_power"
	screen_loc = ui_deitypower
//	layer = HUD_LAYER

/obj/screen/deity_follower_display
	name = "Followers"
	icon_state = "deity_followers"
	screen_loc = ui_deityfollowers
//	layer = HUD_LAYER

/obj/screen/healths/deity
	name = "Nexus Health"
	icon_state = "deity_nexus"
	screen_loc = ui_deityhealth