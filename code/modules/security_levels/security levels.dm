/var/security_level = 0
//0 = code green
//1 = code blue
//2 = code red
//3 = gamma
//4 = epsilon
//5 = code delta

//config.alert_desc_blue_downto
/var/datum/announcement/priority/security/security_announcement_up = new(do_log = 0, do_newscast = 0, new_sound = sound('sound/misc/notice1.ogg'))
/var/datum/announcement/priority/security/security_announcement_down = new(do_log = 0, do_newscast = 0)

/proc/set_security_level(var/level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("blue")
			level = SEC_LEVEL_BLUE
		if("red")
			level = SEC_LEVEL_RED
		if("gamma")
			level = SEC_LEVEL_GAMMA
		if("epsilon")
			level = SEC_LEVEL_EPSILON
		if("delta")
			level = SEC_LEVEL_DELTA

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != security_level)
		switch(level)
			if(SEC_LEVEL_GREEN)
				security_announcement_down.Announce("Todas as ameacas a estacao passaram. Todas as armas precisam ser estofadas e as leis de privacidade sao mais uma vez totalmente cumpridas.","Atencao! Nivel de seguranca baixado para verde.")
				security_level = SEC_LEVEL_GREEN

				post_status("alert", "outline")

				for(var/obj/machinery/firealarm/FA in machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_green")

			if(SEC_LEVEL_BLUE)
				if(security_level < SEC_LEVEL_BLUE)
					security_announcement_up.Announce("A estacao recebeu informacoes confiaveis sobre possiveis atividades hostis na estacao. Os segurancas pode ter armas visiveis e pesquisas aleatorias sao permitidas.","Atencao! Nivel de seguranca elevado ao azul.")
				else
					security_announcement_down.Announce("A ameaca imediata passou. Segurancas ja não podem ter armas em punho em todos os momentos, mas pode continuar a te-los visiveis. Pesquisas aleatórias ainda são permitidas.","Atencao! Nivel de seguranca baixado para azul.")
				security_level = SEC_LEVEL_BLUE

				post_status("alert", "outline")

				for(var/obj/machinery/firealarm/FA in machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_blue")

			if(SEC_LEVEL_RED)
				if(security_level < SEC_LEVEL_RED)
					security_announcement_up.Announce("Existe uma ameaca imediata e seria para a estacao. A seguranca pode ter armas sem limites em todos os momentos. Pesquisas aleatorias sao permitidas e aconselhadas.","Atencao! Codigo vermelho!")
				else
					security_announcement_down.Announce("O mecanismo de autodestruicao da estacao foi desativado, mas ainda ha uma ameaca imediata e seria para a estacao. A seguranca pode ter armas sem limites em todos os momentos. Pesquisas aleatorias sao permitidas e aconselhadas.","Atencao! Codigo vermelho!")
				security_level = SEC_LEVEL_RED

				var/obj/machinery/door/airlock/highsecurity/red/R = locate(/obj/machinery/door/airlock/highsecurity/red) in airlocks
				if(R && is_station_level(R.z))
					R.locked = 0
					R.update_icon()

				post_status("alert", "redalert")

				for(var/obj/machinery/firealarm/FA in machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_red")

			if(SEC_LEVEL_GAMMA)
				security_announcement_up.Announce("O Comando Central ordenou o nivel de seguranca Gamma na estacao. A seguranca e necessario ter armas equipadas em todos os momentos, e todos os civis devem procurar imediatamente um chefe de equipe mais proxima para o transporte para um local seguro. O armario Gamma da estacao foi desbloqueado e esta pronto para uso.","Atencao! Nivel de seguranca Gamma ativado!")
				security_level = SEC_LEVEL_GAMMA

				move_gamma_ship()

				if(security_level < SEC_LEVEL_RED)
					for(var/obj/machinery/door/airlock/highsecurity/red/R in airlocks)
						if(is_station_level(R.z))
							R.locked = 0
							R.update_icon()

				for(var/obj/machinery/door/airlock/hatch/gamma/H in airlocks)
					if(is_station_level(H.z))
						H.locked = 0
						H.update_icon()

				post_status("alert", "gammaalert")

				for(var/obj/machinery/firealarm/FA in machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_gamma")
						FA.update_icon()

			if(SEC_LEVEL_EPSILON)
				security_announcement_up.Announce("O Comando Central ordenou o nivel de seguranca do Epsilon na estacao. Considere todos os contratos encerrados.","Atencao! Nivel de seguranca Epsilon ativado!")
				security_level = SEC_LEVEL_EPSILON

				post_status("alert", "epsilonalert")

				for(var/obj/machinery/firealarm/FA in machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_epsilon")

			if(SEC_LEVEL_DELTA)
				security_announcement_up.Announce("O mecanismo de autodestruicao da estacao foi ativado. Todas as equipes sao instruidas para obedecer todas as instrucoes dadas pelos chefes de equipe. Qualquer violacao dessas ordens pode ser punida com a morte. Esta nao e um treino.","Atencao! Nivel de seguranca Delta alcancado!")
				security_level = SEC_LEVEL_DELTA

				post_status("alert", "deltaalert")

				for(var/obj/machinery/firealarm/FA in machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_delta")

	else
		return

/proc/get_security_level()
	switch(security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_GAMMA)
			return "gamma"
		if(SEC_LEVEL_EPSILON)
			return "epsilon"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(var/num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_GAMMA)
			return "gamma"
		if(SEC_LEVEL_EPSILON)
			return "epsilon"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(var/seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("blue")
			return SEC_LEVEL_BLUE
		if("red")
			return SEC_LEVEL_RED
		if("gamma")
			return SEC_LEVEL_GAMMA
		if("epsilon")
			return SEC_LEVEL_EPSILON
		if("delta")
			return SEC_LEVEL_DELTA


/*DEBUG
/mob/verb/set_thing0()
	set_security_level(0)
/mob/verb/set_thing1()
	set_security_level(1)
/mob/verb/set_thing2()
	set_security_level(2)
/mob/verb/set_thing3()
	set_security_level(3)
*/
