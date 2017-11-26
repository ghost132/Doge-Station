/datum/event/communications_blackout/announce()
	var/alert = pick(	"Anomalias ionosféricas detectadas. Falha temporária nas telecomunicações iminente. Entre em contato com seu*%fj00)`5vc-BZZT", \
						"Anomalias ionosféricas detectadas. Falha temporária nas telec*3mga;b4;'1v?-BZZZT", \
						"Anomalias ionosféricas detectadas. Falha temp#MCi46:5.;@63-BZZZZT", \
						"Anomalias ionosféricas detec'fZ\\kg5_0-BZZZZZT", \
						"Anomalias ionosf:%? MCayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>?%-BZZZZZZZT")

	for(var/mob/living/silicon/ai/A in player_list)	//AIs are always aware of communication blackouts.
		to_chat(A, "<br>")
		to_chat(A, "<span class='warning'><b>[alert]</b></span>")
		to_chat(A, "<br>")

	if(prob(30))	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		event_announcement.Announce(alert)

/datum/event/communications_blackout/start()
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)

/proc/communications_blackout(var/silent = 1)
	if(!silent)
		event_announcement.Announce("Anomalias ionosféricas detectadas. Falha temporária nas telecomunicações iminente. Entre em contato com seu-BZZT", new_sound = 'sound/misc/interference.ogg')
	else // AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
		for(var/mob/living/silicon/ai/A in player_list)
			to_chat(A, "<br>")
			to_chat(A, "<span class='warning'><b>Anomalias ionosféricas detectadas. Falha temporária nas telecomunicações iminente. Entre em contato com seu-BZZT<b></span>")
			to_chat(A, "<br>")
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)
