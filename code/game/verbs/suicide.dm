/mob/var/suiciding = 0

/mob/living/carbon/human/proc/do_suicide(damagetype, byitem)
	var/threshold = (config.health_threshold_crit + config.health_threshold_dead) / 2
	var/dmgamt = maxHealth - threshold

	var/damage_mod = 1
	switch(damagetype) //Sorry about the magic numbers.
					   //brute = 1, burn = 2, tox = 4, oxy = 8
		if(15) //4 damage types
			damage_mod = 4

		if(6, 11, 13, 14) //3 damage types
			damage_mod = 3

		if(3, 5, 7, 9, 10, 12) //2 damage types
			damage_mod = 2

		if(1, 2, 4, 8) //1 damage type
			damage_mod = 1

		else //This should not happen, but if it does, everything should still work
			damage_mod = 1

	//Do dmgamt damage divided by the number of damage types applied.
	if(damagetype & BRUTELOSS)
		adjustBruteLoss(dmgamt / damage_mod)

	if(damagetype & FIRELOSS)
		adjustFireLoss(dmgamt / damage_mod)

	if(damagetype & TOXLOSS)
		adjustToxLoss(dmgamt / damage_mod)

	if(damagetype & OXYLOSS)
		adjustOxyLoss(dmgamt / damage_mod)

	// Failing that...
	if(!(damagetype & BRUTELOSS) && !(damagetype & FIRELOSS) && !(damagetype & TOXLOSS) && !(damagetype & OXYLOSS))
		if(NO_BREATHE in species.species_traits)
			// the ultimate fallback
			take_overall_damage(max(dmgamt - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0), 0)
		else
			adjustOxyLoss(max(dmgamt - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

	var/obj/item/organ/external/affected = get_organ("head")
	if(affected)
		affected.add_autopsy_data(byitem ? "Suicídio por [byitem]" : "Suicídio", dmgamt)

	updatehealth()

/mob/living/carbon/human/verb/suicide()
	set hidden = 1

	if(stat == DEAD)
		to_chat(src, "Você já está morto!")
		return

	if(!ticker)
		to_chat(src, "Você não pode se suicidar antes do início do jogo!")
		return

	// No more borergrief, one way or the other
	if(has_brain_worms())
		to_chat(src, "Você tenta se suicidar, mas algo o impede!")
		return

	if(suiciding)
		to_chat(src, "Você já cometeu suicídio! Seja paciente!")
		return

	var/confirm = alert("Tem certeza de que deseja cometer suicídio?", "Confirme Suicídio", "Sim", "Não")

	if(confirm == "Sim")
		suiciding = 1
		var/obj/item/held_item = get_active_hand()
		if(held_item)
			var/damagetype = held_item.suicide_act(src)
			if(damagetype)
				if(damagetype & SHAME)
					adjustStaminaLoss(200)
					suiciding = 0
					return
				do_suicide(damagetype, held_item)
				return

		to_chat(viewers(src), "<span class=danger>[src] [pick(species.suicide_messages)] parece que eles estão tentando cometer suicídio.</span>")
		do_suicide(0)

		updatehealth()

/mob/living/carbon/brain/verb/suicide()
	set hidden = 1

	if(stat == 2)
		to_chat(src, "Você já está morto!")
		return

	if(!ticker)
		to_chat(src, "Você não pode se suicidar antes do início do jogo!")
		return

	if(suiciding)
		to_chat(src, "Você já cometeu suicídio! Seja paciente!")
		return

	var/confirm = alert("Tem certeza de que deseja cometer suicídio:", "Confirme Suicídio", "Sim", "Não")

	if(confirm == "Sim")
		suiciding = 1
		to_chat(viewers(loc), "<span class='danger'>O cérebro[src] está ficando sem vida e sem vida. Parece que perdeu a vontade de viver.</span>")
		spawn(50)
			death(0)
			suiciding = 0


/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if(stat == 2)
		to_chat(src, "Você já está morto!")
		return

	if(suiciding)
		to_chat(src, "Você já cometeu suicídio! Seja paciente!")
		return

	var/confirm = alert("Tem certeza de que deseja cometer suicídio:", "Confirme Suicídio", "Sim", "Não")

	if(confirm == "Sim")
		suiciding = 1
		to_chat(viewers(src), "<span class='danger'>[src] está apagando. Parece que ele está tentando se suicidar.</span>")
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if(stat == 2)
		to_chat(src, "Você já está morto!")
		return

	if(suiciding)
		to_chat(src, "Você já cometeu suicídio! Seja paciente!")
		return

	var/confirm = alert("Tem certeza de que deseja cometer suicídio:", "Confirme Suicídio", "Sim", "No")

	if(confirm == "Sim")
		suiciding = 1
		to_chat(viewers(src), "<span class='danger'>[src] está se apagando. Parece que ele está tentando se suicidar.</span>")
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Mate-se e torne-se um fantasma (Você receberá um prompt de confirmação)"
	set name = "pAI Suicide"
	var/answer = input("REALMENTE matar-se? Esta ação não pode ser desfeita.", "Suicídio", "Não") in list ("Sim", "Não")
	if(answer == "Yes")
		if(canmove || resting)
			close_up()
		var/obj/item/device/paicard/card = loc
		card.removePersonality()
		var/turf/T = get_turf_or_move(card.loc)
		for(var/mob/M in viewers(T))
			M.show_message("<span class='notice'>[src] pisca uma mensagem na tela, \"Limpando arquivos principais. Adquira uma nova personalidade para continuar usando as funções do dispositivo pAI.\"</span>", 3, "<span class='notice'>[src] </span>", 2)
		death(0, 1)
	else
		to_chat(src, "Abortando tentativa de suicídio.")

/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = 1

	if(stat == 2)
		to_chat(src, "Você já está mort1!!o")
		return

	if(suiciding)
		to_chat(src, "Você já cometeu suicídio! Seja paciente!")
		return

	var/confirm = alert("Tem certeza de que deseja cometer suicídio?", "Confirme Suicídio", "Sim", "Não")

	if(confirm == "Sim")
		suiciding = 1
		to_chat(viewers(src), "<span class='danger'>[src] está batendo descontroladamente! Parece que ele está tentando se suicidar.</span>")
		//put em at -175
		adjustOxyLoss(max(175 - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()


/mob/living/carbon/slime/verb/suicide()
	set hidden = 1
	if(stat == 2)
		to_chat(src, "Você já está morto!")
		return

	if(suiciding)
		to_chat(src, "Você já cometeu suicídio! Seja paciente!")
		return

	var/confirm = alert("Tem certeza de que deseja cometer suicídio?", "Confirme Suicídio", "Sim", "Não")

	if(confirm == "Sim")
		suiciding = 1
		setOxyLoss(100)
		adjustBruteLoss(100 - getBruteLoss())
		setToxLoss(100)
		setCloneLoss(100)

		updatehealth()
