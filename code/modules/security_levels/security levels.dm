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
				security_announcement_down.Announce("Todas as ameaças à estação passaram. Todas as armas precisam ser estofadas e as leis de privacidade são mais uma vez totalmente cumpridas.","Atenção! Nível de segurança baixado para verde.")
				security_level = SEC_LEVEL_GREEN

				post_status("alert", "outline")

				for(var/obj/machinery/firealarm/FA in machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_green")

			if(SEC_LEVEL_BLUE)
				if(security_level < SEC_LEVEL_BLUE)
					security_announcement_up.Announce("A estação recebeu informações confiáveis sobre possíveis atividades hostis na estação. O pessoal de segurança pode ter armas visíveis e pesquisas aleatórias são permitidas.","Atenção! Nível de segurança elevado ao azul.")
				else
					security_announcement_down.Announce("A ameaça imediata passou. Segurança já não podem ter armas em punho em todos os momentos, mas pode continuar a tê-los visíveis. Pesquisas aleatórias ainda são permitidas.","Atenção! Nível de segurança baixado para azul.")
				security_level = SEC_LEVEL_BLUE

				post_status("alert", "outline")

				for(var/obj/machinery/firealarm/FA in machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_blue")

			if(SEC_LEVEL_RED)
				if(security_level < SEC_LEVEL_RED)
					security_announcement_up.Announce("Existe uma ameaça imediata e séria para a estação. A segurança pode ter armas sem limites em todos os momentos. Pesquisas aleatórias são permitidas e aconselhadas.","Atenção! Código vermelho!")
				else
					security_announcement_down.Announce("O mecanismo de autodestruição da estação foi desativado, mas ainda há uma ameaça imediata e séria para a estação. A segurança pode ter armas sem limites em todos os momentos. Pesquisas aleatórias são permitidas e aconselhadas.","Atenção! Código vermelho!")
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
				security_announcement_up.Announce("O Comando Central ordenou o nível de segurança Gamma na estação. A segurança é necessário ter armas equipadas em todos os momentos, e todos os civis devem procurar imediatamente um chefe de equipe mais próxima para o transporte para um local seguro. O armário Gamma da estação foi desbloqueado e está pronto para uso.","Atenção! Nível de segurança Gamma ativado!")
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
				security_announcement_up.Announce("O Comando Central ordenou o nível de segurança do Epsilon na estação. Considere todos os contratos encerrados.","Atenção! Nível de segurança Epsilon ativado!")
				security_level = SEC_LEVEL_EPSILON

				post_status("alert", "epsilonalert")

				for(var/obj/machinery/firealarm/FA in machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_epsilon")

			if(SEC_LEVEL_DELTA)
				security_announcement_up.Announce("O mecanismo de autodestruição da estação foi ativado. Todas as equipes são instruídas para obedecer todas as instruções dadas pelos chefes de equipe. Qualquer violação dessas ordens pode ser punida com a morte. Esta não é um treino.","Atenção! Nível de segurança Delta alcançado!")
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
