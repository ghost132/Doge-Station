turf/portais
	bar_para_galinhas
		name = "portal"
		icon = 'icons/portais.dmi'
		icon_state = "trans"
		Enter() // when you step on it the portal it teleports you to the next exact turf.
			usr.loc = locate(62,28,1)
			usr << "A curiosidade matou o player."