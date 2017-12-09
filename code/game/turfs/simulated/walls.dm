/turf/simulated/wall
	name = "parede"
	desc = "Um grande pedaço de metal usado para separar os quartos."
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"
	var/rotting = 0

	var/damage = 0
	var/damage_cap = 100 //Wall will break down to girders if damage reaches this point

	var/damage_overlay
	var/global/damage_overlays[8]

	var/max_temperature = 1800 //K, walls will take damage if they're next to a fire hotter than this

	opacity = 1
	density = 1
	blocks_air = 1
	explosion_block = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	var/hardness = 40 //lower numbers are harder. Used to determine the probability of a hulk smashing through.
	var/engraving, engraving_quality //engraving on the wall

	var/sheet_type = /obj/item/stack/sheet/metal
	var/sheet_amount = 2
	var/girder_type = /obj/structure/girder
	var/obj/item/stack/sheet/builtin_sheet = null

	canSmoothWith = list(
	/turf/simulated/wall,
	/turf/simulated/wall/r_wall,
	/obj/structure/falsewall,
	/obj/structure/falsewall/reinforced,
	/turf/simulated/wall/rust,
	/turf/simulated/wall/r_wall/rust,
	/turf/simulated/wall/r_wall/coated)
	smooth = SMOOTH_TRUE

/turf/simulated/wall/New()
	..()
	builtin_sheet = new sheet_type

/turf/simulated/wall/BeforeChange()
	for(var/obj/effect/overlay/wall_rot/WR in src)
		qdel(WR)
	. = ..()


//Appearance
/turf/simulated/wall/examine(mob/user)
	. = ..(user)

	if(!damage)
		to_chat(user, "<span class='notice'>Parece totalmente intacto.</span>")
	else
		var/dam = damage / damage_cap
		if(dam <= 0.3)
			to_chat(user, "<span class='warning'>Parece um pouco danificado.</span>")
		else if(dam <= 0.6)
			to_chat(user, "<span class='warning'>Parece moderadamente danificado.</span>")
		else
			to_chat(user, "<span class='danger'>Parece fortemente danificado.</span>")

	if(rotting)
		to_chat(user, "<span class='warning'>Existe um fungo em crescimento [src].</span>")

/turf/simulated/wall/proc/update_icon()
	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	smooth_icon(src)
	if(!damage)
		if(damage_overlay)
			overlays -= damage_overlays[damage_overlay]
			damage_overlay = 0
		return

	var/overlay = round(damage / damage_cap * damage_overlays.len) + 1
	if(overlay > damage_overlays.len)
		overlay = damage_overlays.len

	if(damage_overlay && overlay == damage_overlay) //No need to update.
		return
	if(damage_overlay)
		overlays -= damage_overlays[damage_overlay]
	overlays += damage_overlays[overlay]
	damage_overlay = overlay

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

//Damage

/turf/simulated/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
	return

/turf/simulated/wall/proc/update_damage()
	var/cap = damage_cap
	if(rotting)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

	return

/turf/simulated/wall/proc/adjacent_fire_act(turf/simulated/wall, radiated_temperature)
	if(radiated_temperature > max_temperature)
		take_damage(rand(10, 20) * (radiated_temperature / max_temperature))

/turf/simulated/wall/proc/dismantle_wall(devastated = 0, explode = 0)
	if(devastated)
		devastate_wall()
	else
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		var/newgirder = break_wall()
		if(newgirder) //maybe we don't /want/ a girder!
			transfer_fingerprints_to(newgirder)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	ChangeTurf(/turf/simulated/floor/plating)

/turf/simulated/wall/proc/break_wall()
	new sheet_type(src, sheet_amount)
	return new girder_type(src)

/turf/simulated/wall/proc/devastate_wall()
	new sheet_type(src, sheet_amount)
	new /obj/item/stack/sheet/metal(src)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(/turf/space)
			return
		if(2.0)
			if(prob(50))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1, 1)
		if(3.0)
			take_damage(rand(0, 250))
		else
	return

/turf/simulated/wall/blob_act()
	if(prob(50))
		dismantle_wall()

/turf/simulated/wall/mech_melee_attack(obj/mecha/M)
	if(M.damtype == "brute")
		playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
		M.occupant_message("<span class='danger'>Voce acertou [src].</span>")
		visible_message("<span class='danger'>[src] foi atingido por [M.name].</span>")
		if(prob(5) && M.force > 20)
			dismantle_wall(1)
			M.occupant_message("<span class='warning'>Voce esmaga a parede.</span>")
			visible_message("<span class='warning'>[src.name] esmaga a parede!</span>")
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(!rotting)
		rotting = 1

		var/number_rots = rand(2,3)
		for(var/i=0, i<number_rots, i++)
			new /obj/effect/overlay/wall_rot(src)

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if(istype(sheet_type, /obj/item/stack/sheet/mineral/diamond))
		return

	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = 1
	O.density = 1
	O.layer = 5

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	to_chat(user, "<span class='warning'>O thermite comeca a derreter atraves da parede.</span>")

	spawn(100)
		if(O)	qdel(O)
	return

//Interactions

/turf/simulated/wall/attack_animal(var/mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if(M.environment_smash >= 2)
		if(M.environment_smash == 3)
			dismantle_wall(1)
			to_chat(M, "<span class='info'>Voce esmaga a parede.</span>")
		else
			to_chat(M, text("<span class='notice'>Voce esmaga contra a parede.</span>"))
			take_damage(rand(25, 75))
			return

	to_chat(M, "<span class='notice'>Você empurra a parede, mas nada acontece!</span>")
	return

/turf/simulated/wall/attack_hand(mob/user as mob)
	user.changeNext_move(CLICK_CD_MELEE)
	if(HULK in user.mutations)
		if(prob(hardness) || rotting)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			to_chat(user, text("<span class='notice'>Você esmaga a parede.</span>"))
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			dismantle_wall(1)
			return
		else
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			to_chat(user, text("<span class='notice'>Voce soca a parede.</span>"))
			return

	if(rotting)
		if(hardness <= 10)
			to_chat(user, "<span class='notice'>Essa parede parece bastante instavel.</span>")
			return
		else
			to_chat(user, "<span class='notice'>A parede se desmorona sob seu toque.</span>")
			dismantle_wall()
			return

	to_chat(user, "<span class='notice'>Voce empurra a parede, mas nada acontece!</span>")
	playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
	src.add_fingerprint(user)
	..()
	return

/turf/simulated/wall/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>Voce nao tem a habilidade para fazer isso!</span>")
		return

	//get the user's location
	if(!istype(user.loc, /turf))
		return	//can't do this stuff whilst inside objects and such

	if(rotting)
		if(istype(W, /obj/item/weapon/weldingtool) )
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.remove_fuel(0,user))
				to_chat(user, "<span class='notice'>Voce queima os fungos com \ o [WT].</span>")
				playsound(src, WT.usesound, 10, 1)
				for(var/obj/effect/overlay/wall_rot/WR in src)
					qdel(WR)
				rotting = 0
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, "<span class='notice'>O [src]  [W.name].</span>")
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.remove_fuel(0,user))
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))
			thermitemelt(user)
			return

		else if(istype(W, /obj/item/weapon/melee/energy/blade))
			var/obj/item/weapon/melee/energy/blade/EB = W

			EB.spark_system.start()
			to_chat(user, "<span class='notice'>Voce golpeia com o [EB]; o thermite acende-se!</span>")
			playsound(src, "sparks", 50, 1)
			playsound(src, EB.usesound, 50, 1)

			thermitemelt(user)
			return

	//DECONSTRUCTION
	if(istype(W, /obj/item/weapon/weldingtool))

		var/response = "Dismantle"
		if(damage)
			response = alert(user, "Gostaria de reparar ou desmantelar [src]?", "[src]", "Repair", "Dismantle")

		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0,user))
			if(response == "Repair")
				to_chat(user, "<span class='notice'>Voce comeca a reparar o dano a [src].</span>")
				playsound(src, WT.usesound, 100, 1)
				if(do_after(user, max(5, damage / 5) * WT.toolspeed, target = src) && WT && WT.isOn())
					to_chat(user, "<span class='notice'>Você acabou de reparar o dano [src].</span>")
					take_damage(-damage)

			else if(response == "Dismantle")
				to_chat(user, "<span class='notice'>Voce comeca a cortar o revestimento exterior.</span>")
				playsound(src, WT.usesound, 100, 1)

				if(do_after(user, 100 * WT.toolspeed, target = src) && WT && WT.isOn())
					to_chat(user, "<span class='notice'>Voce remove o revestimento exterior.</span>")
					dismantle_wall()

				else
					to_chat(user, "<span class='warning'>Voce para de cortar [src].</span>")
					return

		else
			to_chat(user, "<span class='notice'>Voce precisa de mais combustivel de soldagem para completar esta tarefa.</span>")
			return

	else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))

		to_chat(user, "<span class='notice'>Voce comeca a cortar o revestimento exterior.</span>")
		playsound(src, W.usesound, 100, 1)

		if(do_after(user, istype(sheet_type, /obj/item/stack/sheet/mineral/diamond) ? 120 * W.toolspeed : 60 * W.toolspeed, target = src))
			to_chat(user, "<span class='notice'>Voce remove o revestimento exterior.</span>")
			dismantle_wall()
			visible_message("<span class='warning'>[user] separa \ o [src]!</span>","<span class='warning'>Voce ouve metal ser cortado.</span>")

	//DRILLING
	else if(istype(W, /obj/item/weapon/pickaxe/drill/diamonddrill))

		to_chat(user, "<span class='notice'>Voce comeca a perfurar a parede.</span>")

		if(do_after(user, istype(sheet_type, /obj/item/stack/sheet/mineral/diamond) ? 480 * W.toolspeed : 240 * W.toolspeed, target = src)) // Diamond pickaxe has 0.25 toolspeed, so 120/60
			to_chat(user, "<span class='notice'>Your drill tears though the last of the reinforced plating.</span>")
			dismantle_wall()
			visible_message("<span class='warning'>[user] perfura atraves do [src]!</span>","<span class='warning'>Voce ouve a moagem de metal.</span>")

	else if(istype(W, /obj/item/weapon/pickaxe/drill/jackhammer))

		to_chat(user, "<span class='notice'>Voce comeca a desintegrar a parede.</span>")

		if(do_after(user, istype(sheet_type, /obj/item/stack/sheet/mineral/diamond) ? 600 * W.toolspeed : 300 * W.toolspeed, target = src)) // Jackhammer has 0.1 toolspeed, so 60/30
			to_chat(user, "<span class='notice'>Seu jato de pressao sonoro desintegra o chapeamento reforcado.</span>")
			dismantle_wall()
			visible_message("<span class='warning'>[user] desintegra \ o [src]!</span>","<span class='warning'>Voce ouve a moagem de metal.</span>")

	else if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/obj/item/weapon/melee/energy/blade/EB = W

		EB.spark_system.start()
		to_chat(user, "<span class='notice'>Voce esfaqueou \ o [EB] na parede e começa a corta-lo.</span>")
		playsound(src, "sparks", 50, 1)

		if(do_after(user, istype(sheet_type, /obj/item/stack/sheet/mineral/diamond) ? 140 * EB.toolspeed : 70 * EB.toolspeed, target = src))
			EB.spark_system.start()
			playsound(src, "sparks", 50, 1)
			playsound(src, EB.usesound, 50, 1)
			dismantle_wall(1)
			visible_message("<span class='warning'>[user] separa \ o [src]!</span>","<span class='warning'>Voce ouve o corte de metal e as faiscas voando.</span>")

	else if(istype(W,/obj/item/mounted)) //if we place it, we don't want to have a silly message
		return

	//Poster stuff
	else if(istype(W, /obj/item/weapon/poster))
		place_poster(W, user)
		return

	//Bone White - Place pipes on walls
	else if(istype(W,/obj/item/pipe))
		var/obj/item/pipe/V = W
		if(V.pipe_type != -1) // ANY PIPE
			var/obj/item/pipe/P = W

			playsound(get_turf(src), 'sound/weapons/circsawhit.ogg', 50, 1)
			user.visible_message( \
				"[user] comeca a perfurar um buraco no [src].", \
				"<span class='notice'>Voce comeca a perfurar um buraco no [src].</span>", \
				"Voce ouve trincheira.")
			if(do_after(user, 80 * W.toolspeed, target = src))
				user.visible_message( \
					"[user] perfura um buraco no [src] perfura um buraco no [P] para o vazio", \
					"<span class='notice'>Voce terminou de perfurar no [src] e empurra o [P] para o vazio.</span>", \
					"Voce ouve trincheira.")

				user.drop_item()
				if(P.is_bent_pipe())  // bent pipe rotation fix see construction.dm
					P.dir = 5
					if(user.dir == 1)
						P.dir = 6
					else if(user.dir == 2)
						P.dir = 9
					else if(user.dir == 4)
						P.dir = 10
				else
					P.dir = user.dir
				P.x = src.x
				P.y = src.y
				P.z = src.z
				P.loc = src
				P.level = 2
		return
	// The magnetic gripper does a separate attackby, so bail from this one
	else if(istype(W, /obj/item/weapon/gripper))
		return

	else
		return attack_hand(user)
	return

/turf/simulated/wall/singularity_pull(S, current_size)
	if(current_size >= STAGE_FIVE)
		if(prob(50))
			dismantle_wall()
		return
	if(current_size == STAGE_FOUR)
		if(prob(30))
			dismantle_wall()

/turf/simulated/wall/narsie_act()
	if(prob(20))
		ChangeTurf(/turf/simulated/wall/cult)
