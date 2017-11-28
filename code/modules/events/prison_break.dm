/datum/event/prison_break
	startWhen		= 5
	announceWhen	= 75

	var/releaseWhen = 60
	var/list/area/areas = list()		//List of areas to affect. Filled by start()

	var/eventDept = "Security"			//Department name in announcement
	var/list/areaName = list("Brig")	//Names of areas mentioned in AI and Engineering announcements
	var/list/areaType = list(/area/security/prison, /area/security/brig, /area/security/permabrig)	//Area types to include.
	var/list/areaNotType = list()		//Area types to specifically exclude.

/datum/event/prison_break/virology
	eventDept = "Medical"
	areaName = list("Virology")
	areaType = list(/area/medical/virology, /area/medical/virology/lab)

/datum/event/prison_break/xenobiology
	eventDept = "Science"
	areaName = list("Xenobiology")
	areaType = list(/area/toxins/xenobiology)
	areaNotType = list(/area/toxins/xenobiology/xenoflora, /area/toxins/xenobiology/xenoflora_storage)

/datum/event/prison_break/station
	eventDept = "Station"
	areaName = list("Brig","Virology","Xenobiology")
	areaType = list(/area/security/prison, /area/security/brig, /area/security/permabrig, /area/medical/virology, /area/medical/virology/lab, /area/toxins/xenobiology)
	areaNotType = list(/area/toxins/xenobiology/xenoflora, /area/toxins/xenobiology/xenoflora_storage)


/datum/event/prison_break/setup()
	announceWhen = rand(75, 105)
	releaseWhen = rand(60, 90)

	src.endWhen = src.releaseWhen+2


/datum/event/prison_break/announce()
	if(areas && areas.len > 0)
		event_announcement.Announce("[pick("Gr3y.T1d3 virus","Malignant trojan")] detectado na [station_name()] [(eventDept == "Security")? "imprisonment":"containment"] sub-rotinas. Proteja imediatamente quaisquer areas comprometidas. O envolvimento da AI da estacao e recomendado.", "[eventDept] Alerta")

/datum/event/prison_break/start()
	for(var/area/A in world)
		if(is_type_in_list(A,areaType) && !is_type_in_list(A,areaNotType))
			areas += A

	if(areas && areas.len > 0)
		var/my_department = "[station_name()] sub-rotinas de firewall"
		var/rc_message = "Um programa mal-intencionado desconhecido foi detectado no [english_list(areaName)] sistemas de controle de iluminacao e [worldtime2text()]. Os sistemas serao totalmente comprometidos dentro de aproximadamente tres minutos. A intervencao direta e necessaria imediatamente.<br>"
		for(var/obj/machinery/message_server/MS in world)
			MS.send_rc_message("Engineering", my_department, rc_message, "", "", 2)
		for(var/mob/living/silicon/ai/A in player_list)
			to_chat(A, "<span class='danger'>Programa malicioso detectado no [english_list(areaName)] sistemas de controle de iluminacao e [my_department].</span>")

	else
		log_runtime("Nao foi possivel iniciar o grey-tide. Nao e possivel encontrar uma area de contencao adequada.", src)
		kill()

/datum/event/prison_break/tick()
	if(activeFor == releaseWhen)
		if(areas && areas.len > 0)
			for(var/area/A in areas)
				for(var/obj/machinery/light/L in A)
					L.flicker(10)

/datum/event/prison_break/end()
	for(var/area/A in shuffle(areas))
		A.prison_break()
