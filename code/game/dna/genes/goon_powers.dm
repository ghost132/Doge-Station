#define EAT_MOB_DELAY 300 // 30s

// WAS: /datum/bioEffect/alcres
/datum/dna/gene/basic/sober
	name="Sobrio"
	activation_messages=list("Você se sente excepcionalmente sóbrio.")
	deactivation_messages = list("Você sente que pode beber mais.")

	mutation=SOBER

/datum/dna/gene/basic/sober/New()
	block=SOBERBLOCK

//WAS: /datum/bioEffect/psychic_resist
/datum/dna/gene/basic/psychic_resist
	name="Resistencia-psiquica"
	desc = "Aumenta a eficiência em setores do cérebro comumente associados a energias meta-mentais."
	activation_messages = list("Você sente sua mente se fechar.")
	deactivation_messages = list("Você se sente estranhamente exposto.")

	mutation=PSY_RESIST

/datum/dna/gene/basic/psychic_resist/New()
	block=PSYRESISTBLOCK

/////////////////////////
// Stealth Enhancers
/////////////////////////

/datum/dna/gene/basic/stealth
	instability = GENE_INSTABILITY_MODERATE

/datum/dna/gene/basic/stealth/can_activate(var/mob/M, var/flags)
	// Can only activate one of these at a time.
	if(is_type_in_list(/datum/dna/gene/basic/stealth,M.active_genes))
		testing("Cannot activate [type]: /datum/dna/gene/basic/stealth in M.active_genes.")
		return 0
	return ..(M,flags)

/datum/dna/gene/basic/stealth/deactivate(var/mob/M)
	..(M)
	M.alpha=255

// WAS: /datum/bioEffect/darkcloak
/datum/dna/gene/basic/stealth/darkcloak
	name = "Capa da Escuridão"
	desc = "Permite ao sujeito dobrar níveis baixos de luz em torno de si mesmos, criando um efeito de capa."
	activation_messages = list("Você começou a desaparecer nas sombras.")
	deactivation_messages = list("Você se tornou totalmente visivel.")
	activation_prob=25
	mutation = CLOAK

/datum/dna/gene/basic/stealth/darkcloak/New()
	block=SHADOWBLOCK

/datum/dna/gene/basic/stealth/darkcloak/OnMobLife(var/mob/M)
	var/turf/simulated/T = get_turf(M)
	if(!istype(T))
		return
	var/light_available = T.get_lumcount() * 10
	if(light_available <= 2)
		M.alpha = round(M.alpha * 0.8)
	else
		M.alpha = 255

//WAS: /datum/bioEffect/chameleon
/datum/dna/gene/basic/stealth/chameleon
	name = "Camaleão"
	desc = "O sujeito torna-se capaz de alterar sutilmente padrões de luz para se tornar invisível, desde que permaneçam imóveis."
	activation_messages = list("Você se tente um só com o ambiente.")
	deactivation_messages = list("Você se sente estranhamente visivel.")
	activation_prob=25
	mutation = CHAMELEON

/datum/dna/gene/basic/stealth/chameleon/New()
		block=CHAMELEONBLOCK

/datum/dna/gene/basic/stealth/chameleon/OnMobLife(var/mob/M)
	if((world.time - M.last_movement) >= 30 && !M.stat && M.canmove && !M.restrained())
		M.alpha -= 25
	else
		M.alpha = round(255 * 0.80)

/////////////////////////////////////////////////////////////////////////////////////////

/datum/dna/gene/basic/grant_spell
	var/obj/effect/proc_holder/spell/spelltype

/datum/dna/gene/basic/grant_spell/activate(var/mob/M, var/connected, var/flags)
	M.AddSpell(new spelltype(null))
	..()
	return 1

/datum/dna/gene/basic/grant_spell/deactivate(var/mob/M, var/connected, var/flags)
	for(var/obj/effect/proc_holder/spell/S in M.mob_spell_list)
		if(istype(S, spelltype))
			M.RemoveSpell(S)
	..()
	return 1

/datum/dna/gene/basic/grant_verb
	var/verbtype

/datum/dna/gene/basic/grant_verb/activate(var/mob/M, var/connected, var/flags)
	..()
	M.verbs += verbtype
	return 1

/datum/dna/gene/basic/grant_verb/deactivate(var/mob/M, var/connected, var/flags)
	..()
	M.verbs -= verbtype

// WAS: /datum/bioEffect/cryokinesis
/datum/dna/gene/basic/grant_spell/cryo
	name = "Criosinesi"
	desc = "Permite que o sujeito diminua a temperatura corporal dos outros."
	activation_messages = list("Você percebe um estranho formigamento frio na ponta dos seus dedos.")
	deactivation_messages = list("Your fingers feel warmer.")
	instability = GENE_INSTABILITY_MODERATE
	mutation = CRYO

	spelltype = /obj/effect/proc_holder/spell/targeted/cryokinesis

/datum/dna/gene/basic/grant_spell/cryo/New()
	..()
	block = CRYOBLOCK

/obj/effect/proc_holder/spell/targeted/cryokinesis
	name = "Criosinesi"
	desc = "Faz a temperatura corporal dos outros cair."
	panel = "Abilities"

	charge_type = "recharge"
	charge_max = 1200

	clothes_req = 0
	stat_allowed = 0
	invocation_type = "none"
	range = 7
	selection_type = "range"
	include_user = 1
	var/list/compatible_mobs = list(/mob/living/carbon/human)

	action_icon_state = "genetic_cryo"

/obj/effect/proc_holder/spell/targeted/cryokinesis/cast(list/targets, mob/user = usr)
	if(!targets.len)
		to_chat(user, "<span class='notice'>Nenhum alvo encontrado ao alcance.</span>")
		return

	var/mob/living/carbon/C = targets[1]

	if(!iscarbon(C))
		to_chat(user, "<span class='warning'>Isso só funciona em corpos organicos.</span>")
		return

	if(RESIST_COLD in C.mutations)
		C.visible_message("<span class='warning'>Uma nuvem de cristais finos envolvem [C.name], mas desapareceu quase que instantaneamente!</span>")
		return
	var/handle_suit = 0
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(istype(H.head, /obj/item/clothing/head/helmet/space))
			if(istype(H.wear_suit, /obj/item/clothing/suit/space))
				handle_suit = 1
				if(H.internal)
					H.visible_message("<span class='warning'>[user] jogou uma nuvem de cristais finos, envolvendo [H]!</span>",
										"<span class='notice'>[user] jogou uma nuvem de  [H.head].</span>")
					log_admin("[key_name(user)] has used cryokinesis on [key_name(C)] while wearing internals and a suit")
					msg_admin_attack("[key_name_admin(user)] lançou cryokinesis em [key_name_admin(C)]")
				else
					H.visible_message("<span class='warning'>[user] jogou uma nuvem de cristais finos, envolvendo, [H]!</span>",
										"<span class='warning'>[user] jogou uma nuvem de cristais finos cobrindo se [H.head] e entre em suas saídas de ar!.</span>")
					log_admin("[key_name(user)] lançou cryokinesis em [key_name(C)]")
					msg_admin_attack("[key_name_admin(user)] has cast cryokinesis on [key_name_admin(C)]")
					H.bodytemperature = max(0, H.bodytemperature - 50)
					H.adjustFireLoss(5)
	if(!handle_suit)
		C.bodytemperature = max(0, C.bodytemperature - 100)
		C.adjustFireLoss(10)
		C.ExtinguishMob()

		C.visible_message("<span class='warning'>[user] jogou uma nuvem de cristais finos, envolvendo [C]!</span>")
		log_admin("[key_name(user)] usou a criosinesi em [key_name(C)] sem cilindros ou roupas")
		msg_admin_attack("[key_name_admin(user)] lançou a criosinese em [key_name_admin(C)]")

	//playsound(user.loc, 'bamf.ogg', 50, 0)

	new/obj/effect/self_deleting(C.loc, icon('icons/effects/genetics.dmi', "cryokinesis"))

	return

/obj/effect/self_deleting
	density = 0
	opacity = 0
	anchored = 1
	icon = null
	desc = ""
	//layer = 15

/obj/effect/self_deleting/New(var/atom/location, var/icon/I, var/duration = 20, var/oname = "something")
	src.name = oname
	loc=location
	src.icon = I
	spawn(duration)
		qdel(src)

///////////////////////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/mattereater
/datum/dna/gene/basic/grant_spell/mattereater
	name = "Mattador de Materia"
	desc = "Permite que o sujeito coma praticamente qualquer coisa sem danos."
	activation_messages = list("Você sente fome.")
	deactivation_messages = list("Você não tem mais fome.")
	instability = GENE_INSTABILITY_MINOR
	mutation = EATER

	spelltype=/obj/effect/proc_holder/spell/targeted/eat

/datum/dna/gene/basic/grant_spell/mattereater/New()
	..()
	block = EATBLOCK

/obj/effect/proc_holder/spell/targeted/eat
	name = "Comer"
	desc = "Come quase tudo!"
	panel = "Abilities"

	charge_type = "recharge"
	charge_max = 300

	clothes_req = 0
	stat_allowed = 0
	invocation_type = "none"
	range = 1
	selection_type = "view"

	action_icon_state = "genetic_eat"

	var/list/types_allowed = list(
		/obj/item,
		/mob/living/simple_animal/pet,
		/mob/living/simple_animal/hostile,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/crab,
		/mob/living/simple_animal/mouse,
		/mob/living/carbon/human,
		/mob/living/carbon/slime,
		/mob/living/carbon/alien/larva,
		/mob/living/simple_animal/slime,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/chicken,
		/mob/living/simple_animal/lizard,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/spiderbot
	)
	var/list/own_blacklist = list(
		/obj/item/organ,
		/obj/item/weapon/implant
	)

/obj/effect/proc_holder/spell/targeted/eat/proc/doHeal(var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/name in H.bodyparts_by_name)
			var/obj/item/organ/external/affecting = null
			if(!H.bodyparts_by_name[name])
				continue
			affecting = H.bodyparts_by_name[name]
			if(!istype(affecting, /obj/item/organ/external))
				continue
			affecting.heal_damage(4, 0)
		H.UpdateDamageIcon()
		H.updatehealth()

/obj/effect/proc_holder/spell/targeted/eat/choose_targets(mob/user = usr)
	var/list/targets = new /list()
	var/list/possible_targets = new /list()

	if(!check_mouth(user))
		revert_cast(user)
		return

	for(var/atom/movable/O in view_or_range(range, user, selection_type))
		if((O in user) && is_type_in_list(O,own_blacklist))
			continue
		if(is_type_in_list(O,types_allowed))
			if(isanimal(O))
				var/mob/living/simple_animal/SA = O
				if(!SA.gold_core_spawnable)
					continue
			possible_targets += O

	targets += input("Escolha o alvo para a sua fome.", "Mirando") as null|anything in possible_targets

	if(!targets.len || !targets[1]) //doesn't waste the spell
		revert_cast(user)
		return

	if(!check_mouth(user))
		revert_cast(user)
		return

	perform(targets, user = user)

/obj/effect/proc_holder/spell/targeted/eat/proc/check_mouth(mob/user = usr)
	var/can_eat = 1
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if((C.head && (C.head.flags_cover & HEADCOVERSMOUTH)) || (C.wear_mask && (C.wear_mask.flags_cover & MASKCOVERSMOUTH) && !C.wear_mask.mask_adjusted))
			to_chat(C, "<span class='warning'>Sua boca está cheia, impedindo você de comer!</span>")
			can_eat = 0
	return can_eat

/obj/effect/proc_holder/spell/targeted/eat/cast(list/targets, mob/user = usr)
	if(!targets.len)
		to_chat(user, "<span class='notice'>Nenhum alvo encontrado ao alcance.</span>")
		return

	var/atom/movable/the_item = targets[1]
	if(ishuman(the_item))
		//My gender
		var/m_his = "his"
		if(user.gender == FEMALE)
			m_his = "her"
		// Their gender
		var/t_his = "his"
		if(the_item.gender == FEMALE)
			t_his = "her"
		var/mob/living/carbon/human/H = the_item
		var/obj/item/organ/external/limb = H.get_organ(user.zone_sel.selecting)
		if(!istype(limb))
			to_chat(user, "<span class='warning'>Você não pode comer uma parte disso!</span>")
			revert_cast()
			return 0
		if(istype(limb,/obj/item/organ/external/head))
			// Bullshit, but prevents being unable to clone someone.
			to_chat(user, "<span class='warning'>Você tentou colocar \the [limb] na boca, mas [t_his] As orelhas fazem cócegas na garganta!</span>")
			revert_cast()
			return 0
		if(istype(limb,/obj/item/organ/external/chest))
			// Bullshit, but prevents being able to instagib someone.
			to_chat(user, "<span class='warning'>Você tentou colocar [limb] dele em sua boca, mas é muito grande para caber!</span>")
			revert_cast()
			return 0
		user.visible_message("<span class='danger'>[user] begins stuffing [the_item]'s [limb.name] into [m_his] gaping maw!</span>")
		var/oldloc = H.loc
		if(!do_mob(user,H,EAT_MOB_DELAY))
			to_chat(user, "<span class='danger'>Você foi interrompido antes de poder comer [the_item]!</span>")
		else
			if(!limb || !H)
				return
			if(H.loc != oldloc)
				to_chat(user, "<span class='danger'>\The [limb] de moveu para fora da boca!</span>")
				return
			user.visible_message("<span class='danger'>[user] [pick("chomps","bites")] off [the_item]'s [limb]!</span>")
			playsound(user.loc, 'sound/items/eatfood.ogg', 50, 0)
			limb.droplimb(0, DROPLIMB_SHARP)
			doHeal(user)
	else
		user.visible_message("<span class='danger'>[user] comeu \the [the_item].</span>")
		playsound(user.loc, 'sound/items/eatfood.ogg', 50, 0)
		qdel(the_item)
		doHeal(user)
	return

////////////////////////////////////////////////////////////////////////

//WAS: /datum/bioEffect/jumpy
/datum/dna/gene/basic/grant_spell/jumpy
	name = "Saltador"
	desc = "Permite que o sujeito salte longas distancias."
	//cooldown = 30
	activation_messages = list("Você sente que os musculos das suas pernas estão mais fortes.")
	deactivation_messages = list("Você sente os musculos das suas pernas voltarem ao normal.")
	instability = GENE_INSTABILITY_MINOR
	mutation = JUMPY

	spelltype =/obj/effect/proc_holder/spell/targeted/leap

/datum/dna/gene/basic/grant_spell/jumpy/New()
	..()
	block = JUMPBLOCK

/obj/effect/proc_holder/spell/targeted/leap
	name = "Saltar"
	desc = "Salta grandes distancias!"
	panel = "Abilities"
	range = -1
	include_user = 1

	charge_type = "recharge"
	charge_max = 60

	clothes_req = 0
	stat_allowed = 0
	invocation_type = "none"

	action_icon_state = "genetic_jump"

/obj/effect/proc_holder/spell/targeted/leap/cast(list/targets, mob/user = usr)
	var/failure = 0
	if(istype(user.loc,/mob/) || user.lying || user.stunned || user.buckled || user.stat)
		to_chat(user, "<span class='warning'>Você não pode pular agora!</span>")
		return

	if(istype(user.loc,/turf/))
		if(user.restrained())//Why being pulled while cuffed prevents you from moving
			for(var/mob/M in range(user, 1))
				if(M.pulling == user)
					if(!M.restrained() && M.stat == 0 && M.canmove && user.Adjacent(M))
						failure = 1
					else
						M.stop_pulling()

		user.visible_message("<span class='danger'>[user.name]</b> deu um salto muito grande!</span>")
		playsound(user.loc, 'sound/weapons/thudswoosh.ogg', 50, 1)
		if(failure)
			user.Weaken(5)
			user.Stun(5)
			user.visible_message("<span class='warning'>[user] tentou sair pulando mas se esborrachou no chão!</span>",
								"<span class='warning'>Você tentou sair pulando mas se esborrachou no chão!</span>",
								"<span class='notice'>Você ouve a contração de músculos poderosos e de repente um acidente como um corpo atinge o chão.</span>")
			return 0
		var/prevLayer = user.layer
		var/prevFlying = user.flying
		user.layer = 9

		user.flying = 1
		for(var/i=0, i<10, i++)
			step(user, user.dir)
			if(i < 5) user.pixel_y += 8
			else user.pixel_y -= 8
			sleep(1)
		user.flying = prevFlying

		if(FAT in user.mutations && prob(66))
			user.visible_message("<span class='danger'>[user.name]</b> falhou devido ao peso dele!</span>")
			//playsound(user.loc, 'zhit.wav', 50, 1)
			user.AdjustWeakened(10)
			user.AdjustStunned(5)

		user.layer = prevLayer

	if(istype(user.loc,/obj/))
		var/obj/container = user.loc
		to_chat(user, "<span class='warning'>Você tentou pular, mas caiu no [container]! Caralho Borracha!</span>")
		user.AdjustParalysis(3)
		user.AdjustWeakened(5)
		container.visible_message("<span class='danger'>[user.loc]</b> emits a loud thump and rattles a bit.</span>")
		playsound(user.loc, 'sound/effects/bang.ogg', 50, 1)
		var/wiggle = 6
		while(wiggle > 0)
			wiggle--
			container.pixel_x = rand(-3,3)
			container.pixel_y = rand(-3,3)
			sleep(1)
		container.pixel_x = 0
		container.pixel_y = 0

////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/polymorphism

/datum/dna/gene/basic/grant_spell/polymorph
	name = "Polimorfismo"
	desc = "Permite que o sujeito mude sua aparencia."

	spelltype =/obj/effect/proc_holder/spell/targeted/polymorph
	//cooldown = 1800
	activation_messages = list("De alguma forma, você não se sente você mesmo.")
	deactivation_messages = list("Você se sente mais seguro com sua identidade.")
	instability = GENE_INSTABILITY_MODERATE
	mutation = POLYMORPH

/datum/dna/gene/basic/grant_spell/polymorph/New()
	..()
	block = POLYMORPHBLOCK

/obj/effect/proc_holder/spell/targeted/polymorph
	name = "Polymorph"
	desc = "Imita a aparencia dos outros"
	panel = "Abilities"
	charge_max = 1800

	clothes_req = 0
	human_req = 1
	stat_allowed = 0
	invocation_type = "none"
	range = 1
	selection_type = "range"

	action_icon_state = "genetic_poly"

/obj/effect/proc_holder/spell/targeted/polymorph/cast(list/targets, mob/user = usr)
	var/mob/living/M = targets[1]
	if(!ishuman(M))
		to_chat(usr, "<span class='warning'>Você só pode trocar de aparencia com outro humano.</span>")
		return

	user.visible_message("<span class='warning'>O corpo de [user] começa a se contorcer(que cena horrivel).</span>")

	spawn(10)
		if(M && user)
			playsound(user.loc, 'sound/goonstation/effects/gib.ogg', 50, 1)
			var/mob/living/carbon/human/H = user
			var/mob/living/carbon/human/target = M
			H.UpdateAppearance(target.dna.UI)
			H.real_name = target.real_name
			H.name = target.name

////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/empath
/datum/dna/gene/basic/grant_spell/empath
	name = "Pensamento empático"
	desc = "O sujeito está apto a ler a mente de alguem e obter informaçoes."

	spelltype = /obj/effect/proc_holder/spell/targeted/empath
	activation_messages = list("Subitamente você começa a saber mais sobre os outros.")
	deactivation_messages = list("Você não tem mais o senso da intenções.")
	instability = GENE_INSTABILITY_MINOR
	mutation=EMPATH

/datum/dna/gene/basic/grant_spell/empath/New()
	..()
	block = EMPATHBLOCK

/obj/effect/proc_holder/spell/targeted/empath
	name = "Ler mente"
	desc = "Ler a mente dos outros para obter informações."
	charge_max = 180
	clothes_req = 0
	human_req = 1
	stat_allowed = 0
	invocation_type = "none"
	range = -2
	selection_type = "range"

	action_icon_state = "genetic_empath"

/obj/effect/proc_holder/spell/targeted/empath/choose_targets(mob/user = usr)
	var/list/targets = new /list()
	targets += input("Escolha o alvo que quer espionar.", "Mirando") as null|mob in range(7,usr)

	if(!targets.len || !targets[1]) //doesn't waste the spell
		revert_cast(user)
		return

	perform(targets, user = user)

/obj/effect/proc_holder/spell/targeted/empath/cast(list/targets, mob/user = usr)
	for(var/mob/living/carbon/M in targets)
		if(!iscarbon(M))
			to_chat(user, "<span class='warning'>Você so pode usar isso em outros organicos.</span>")
			return

		if(PSY_RESIST in M.mutations)
			to_chat(user, "<span class='warning'>Você nao consegue ler a mente de [M.name]!</span>")
			return

		if(M.stat == 2)
			to_chat(user, "<span class='warning'>[M.name] está morto, você não consegue ler a mente dele.</span>")
			return
		if(M.health < 0)
			to_chat(user, "<span class='warning'>[M.name] está morrendo, e seus pensamentos estão muito mexidos para ler.</span>")
			return

		to_chat(user, "<span class='notice'>Lendo a mente de <b>[M.name]:</b></span>")

		var/pain_condition = M.health / M.maxHealth
		// lower health means more pain
		var/list/randomthoughts = list("O que tem pro almoço","o futuro","o passado","dinheiro",
		"seu cabelo","o que eu faço agora?","seu trabalho","espaço","coisas divertidas","coisas tristes",
		"annoying things","happy things","something incoherent","something they did wrong")
		var/thoughts = "thinking about [pick(randomthoughts)]"

		if(M.fire_stacks)
			pain_condition -= 0.5
			thoughts = "preoccupied with the fire"

		if(M.radiation)
			pain_condition -= 0.25

		switch(pain_condition)
			if(0.81 to INFINITY)
				to_chat(user, "<span class='notice'><b>Condition</b>: [M.name] se sente bem.</span>")
			if(0.61 to 0.8)
				to_chat(user, "<span class='notice'><b>Condition</b>: [M.name] está com uma dorzinha.</span>")
			if(0.41 to 0.6)
				to_chat(user, "<span class='notice'><b>Condition</b>: [M.name] está com dor.</span>")
			if(0.21 to 0.4)
				to_chat(user, "<span class='notice'><b>Condition</b>: [M.name] está com dor forte(toma dorflex).</span>")
			else
				to_chat(user, "<span class='notice'><b>Condition</b>: [M.name] está com uma dor excruciante(morre logo poha!).</span>")
				thoughts = "haunted by their own mortality"

		switch(M.a_intent)
			if(INTENT_HELP)
				to_chat(user, "<span class='notice'><b>Mood</b>: Você sente pensamentos benevolentes de [M.name].</span>")
			if(INTENT_DISARM)
				to_chat(user, "<span class='notice'><b>Mood</b>: Você sente pensamentos cautelosos de [M.name].</span>")
			if(INTENT_GRAB)
				to_chat(user, "<span class='notice'><b>Mood</b>: Você sente pensamentos hostis de [M.name].</span>")
			if(INTENT_HARM)
				to_chat(user, "<span class='notice'><b>Mood</b>: Você sente pensamentos cruéis de [M.name].</span>")
				for(var/mob/living/L in view(7,M))
					if(L == M)
						continue
					thoughts = "thinking about punching [L.name]"
					break
			else
				to_chat(user, "<span class='notice'><b>Mood</b>: Você sente pensamentos estranhos de [M.name].</span>")

		if(istype(M,/mob/living/carbon/human))
			var/numbers[0]
			var/mob/living/carbon/human/H = M
			if(H.mind && H.mind.initial_account)
				numbers += H.mind.initial_account.account_number
				numbers += H.mind.initial_account.remote_access_pin
			if(numbers.len>0)
				to_chat(user, "<span class='notice'><b>Numbers</b>: Você sente qu o numero[numbers.len>1?"s":""] [english_list(numbers)] [numbers.len>1?"are":"is"] é importante para [M.name].</span>")
		to_chat(user, "<span class='notice'><b>Thoughts</b>: [M.name] is currently [thoughts].</span>")

		if(EMPATH in M.mutations)
			to_chat(M, "<span class='warning'>Você sente que [user.name] está lendo a sua mente.</span>")
		else if(prob(5) || M.mind.assigned_role=="Chaplain")
			to_chat(M, "<span class='warning'>Você sente alguem invadindo seus penssamentos...</span>")
		return

////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/superfart
/datum/dna/gene/basic/grant_spell/superfart
	name = "Intestinos de Alta Pressão"
	desc = "Aumenta a capacidade de gases no trato digestivo."
	activation_messages = list("Você sente que está cheio de gases.")
	deactivation_messages = list("Você não sente mais os gases. Que alivio!")
	instability = GENE_INSTABILITY_MINOR
	mutation = SUPER_FART
	spelltype = /obj/effect/proc_holder/spell/aoe_turf/superfart

/datum/dna/gene/basic/grant_spell/superfart/New()
	..()
	block = SUPERFARTBLOCK

/obj/effect/proc_holder/spell/aoe_turf/superfart
	name = "Super Peido"
	desc = "Peida com a furia de 1000 paneladas de feijoada."
	panel = "Abilities"
	charge_max = 900
	invocation_type = "emote"
	range = 3
	clothes_req = 0
	selection_type = "view"
	action_icon_state = "superfart"

/obj/effect/proc_holder/spell/aoe_turf/superfart/invocation(mob/user = usr)
	invocation = "<span class='warning'>[user] está rangendo os dentes!</span>"
	invocation_emote_self = "<span class='warning'>Você range bem os dentes!</span>"
	..(user)

/obj/effect/proc_holder/spell/aoe_turf/superfart/cast(list/targets, mob/user)
	var/UT = get_turf(user)
	if(do_after(user, 30, target = user))
		var/fartsize = pick("tremendous","gigantic","colossal")
		playsound(UT, 'sound/goonstation/effects/superfart.ogg', 50, 0)
		user.visible_message("<span class='warning'><b>[user]</b> soltou um peido [fartsize]!</span>", "<span class='warning'>Você escutou um peido [fartsize].</span>")
		for(var/T in targets)
			for(var/mob/living/M in T)
				shake_camera(M, 10, 5)
				if(M == user)
					continue
				to_chat(M, "<span class='warning'>Você saiu voando!</span>")
				M.Weaken(5)
				step_away(M, UT, 15)
				step_away(M, UT, 15)
				step_away(M, UT, 15)
	else
		to_chat(user, "<span class='warning'>Você foi interrompido e não conseguiu peidar! Mal educado!</span>")
