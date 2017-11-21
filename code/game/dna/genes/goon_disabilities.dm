//////////////////
// DISABILITIES //
//////////////////

////////////////////////////////////////
// Totally Crippling
////////////////////////////////////////

// WAS: /datum/bioEffect/mute
/datum/dna/gene/disability/mute
	name = "Mudo"
	desc = "Desligue completamente o centro de fala do cérebro do sujeito."
	activation_message   = "Você se sente incapaz de se expressar."
	deactivation_message = "Você se sente capaz de falar livremente novamente."
	instability = -GENE_INSTABILITY_MODERATE
	disability = MUTE

/datum/dna/gene/disability/mute/New()
	..()
	block=MUTEBLOCK

/datum/dna/gene/disability/mute/OnSay(var/mob/M, var/message)
	return ""

////////////////////////////////////////
// Harmful to others as well as self
////////////////////////////////////////

/datum/dna/gene/disability/radioactive
	name = "Radioativo"
	desc = "O sujeito sofre de doença de radiação constante e causa o mesmo em orgânicos próximos."
	activation_message = "Você sente uma doença estranha permear todo o seu corpo."
	deactivation_message = "Você já não se sente horrivelmente e doente por toda parte."
	instability = -GENE_INSTABILITY_MAJOR
	mutation = RADIOACTIVE

/datum/dna/gene/disability/radioactive/New()
	..()
	block=RADBLOCK


/datum/dna/gene/disability/radioactive/can_activate(var/mob/M,var/flags)
	if(!..())
		return 0
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if((RADIMMUNE in H.species.species_traits) && !(flags & MUTCHK_FORCED))
			return 0
	return 1

/datum/dna/gene/disability/radioactive/OnMobLife(var/mob/living/owner)
	var/radiation_amount = abs(min(owner.radiation - 20,0))
	owner.apply_effect(radiation_amount, IRRADIATE)
	for(var/mob/living/L in range(1, owner))
		if(L == owner)
			continue
		to_chat(L, "<span class='danger'>Você está envolvido por um brilho verde suave que emana de [owner].</span>")
		L.apply_effect(5, IRRADIATE)
	return

/datum/dna/gene/disability/radioactive/OnDrawUnderlays(var/mob/M,var/g,var/fat)
	return "rads[fat]_s"

////////////////////////////////////////
// Other disabilities
////////////////////////////////////////

// WAS: /datum/bioEffect/fat
/datum/dna/gene/disability/fat
	name = "Obesidade"
	desc = "Realmente retarda o metabolismo do sujeito, permitindo maior acúmulo de tecido lipídico."
	activation_message = "Você sente blubbery e letárgico!"
	deactivation_message = "Você se sente bem!"
	instability = -GENE_INSTABILITY_MINOR
	mutation = OBESITY

/datum/dna/gene/disability/fat/New()
	..()
	block=FATBLOCK

// WAS: /datum/bioEffect/chav
/datum/dna/gene/disability/speech/chav
	name = "Chav"
	desc = "Força o centro de linguagem do cérebro do sujeito a construir frases de maneira mais rudimentar."
	activation_message = "Você se sente como um homem da caverna?"
	deactivation_message = "Você não sente vontade de ser grosseiro e resmungão."
	mutation = CHAV

/datum/dna/gene/disability/speech/chav/New()
	..()
	block=CHAVBLOCK

/datum/dna/gene/disability/speech/chav/OnSay(var/mob/M, var/message)
	// THIS ENTIRE THING BEGS FOR REGEX
	message = replacetext(message,"dick","prat")
	message = replacetext(message,"comdom","knob'ead")
	message = replacetext(message,"looking at","gawpin' at")
	message = replacetext(message,"great","bangin'")
	message = replacetext(message,"man","mate")
	message = replacetext(message,"friend",pick("mate","bruv","bledrin"))
	message = replacetext(message,"what","wot")
	message = replacetext(message,"drink","wet")
	message = replacetext(message,"get","giz")
	message = replacetext(message,"what","wot")
	message = replacetext(message,"no thanks","wuddent fukken do one")
	message = replacetext(message,"i don't know","wot mate")
	message = replacetext(message,"no","naw")
	message = replacetext(message,"robust","chin")
	message = replacetext(message," hi ","how what how")
	message = replacetext(message,"hello","sup bruv")
	message = replacetext(message,"kill","bang")
	message = replacetext(message,"murder","bang")
	message = replacetext(message,"windows","windies")
	message = replacetext(message,"window","windy")
	message = replacetext(message,"break","do")
	message = replacetext(message,"your","yer")
	message = replacetext(message,"security","coppers")
	return message

// WAS: /datum/bioEffect/swedish
/datum/dna/gene/disability/speech/swedish
	name = "sueco"
	desc = "Força o centro de linguagem do cérebro do sujeito a construir frases de forma vagamente nórdica."
	activation_message = "Você se sente sueco, no entanto, isso funciona."
	deactivation_message = "A sensação de sueca passou."
	mutation = SWEDISH

/datum/dna/gene/disability/speech/swedish/New()
	..()
	block=SWEDEBLOCK

/datum/dna/gene/disability/speech/swedish/OnSay(var/mob/M, var/message)
	// svedish
	message = replacetextEx(message,"W","V")
	message = replacetextEx(message,"w","v")
	message = replacetextEx(message,"J","Y")
	message = replacetextEx(message,"j","y")
	message = replacetextEx(message,"A",pick("Ã…","Ã„","Ã†","A"))
	message = replacetextEx(message,"a",pick("Ã¥","Ã¤","Ã¦","a"))
	message = replacetextEx(message,"BO","BJO")
	message = replacetextEx(message,"Bo","Bjo")
	message = replacetextEx(message,"bo","bjo")
	message = replacetextEx(message,"O",pick("Ã–","Ã˜","O"))
	message = replacetextEx(message,"o",pick("Ã¶","Ã¸","o"))
	if(prob(30))
		message += " Bork[pick("",", bork",", bork, bork")]!"
	return message

// WAS: /datum/bioEffect/unintelligable
/datum/dna/gene/disability/unintelligable
	name = "Retardado"
	desc = "Corrige fortemente a parte do cérebro responsável pela formação de frases faladas."
	activation_message = "Você não consegue formar pensamentos coerentes!"
	deactivation_message = "Sua mente está mais clara."
	instability = -GENE_INSTABILITY_MINOR
	mutation = SCRAMBLED

/datum/dna/gene/disability/unintelligable/New()
	..()
	block=SCRAMBLEBLOCK

/datum/dna/gene/disability/unintelligable/OnSay(var/mob/M, var/message)
	var/prefix=copytext(message,1,2)
	if(prefix == ";")
		message = copytext(message,2)
	else if(prefix in list(":","#"))
		prefix += copytext(message,2,3)
		message = copytext(message,3)
	else
		prefix=""

	var/list/words = splittext(message," ")
	var/list/rearranged = list()
	for(var/i=1;i<=words.len;i++)
		var/cword = pick(words)
		words.Remove(cword)
		var/suffix = copytext(cword,length(cword)-1,length(cword))
		while(length(cword)>0 && suffix in list(".",",",";","!",":","?"))
			cword  = copytext(cword,1              ,length(cword)-1)
			suffix = copytext(cword,length(cword)-1,length(cword)  )
		if(length(cword))
			rearranged += cword
	return "[prefix][uppertext(jointext(rearranged," "))]!!"

// WAS: /datum/bioEffect/toxic_farts
/datum/dna/gene/disability/toxic_farts
	name = "Peidos Toxico"
	desc = "Causa a digestão do sujeito para criar uma quantidade significativa de gás nocivo."
	activation_message = "Seu estômago resmunga desagradavelmente."
	deactivation_message = "Seu estômago deixa de agir. Phew!"
	mutation = TOXIC_FARTS

/datum/dna/gene/disability/toxic_farts/New()
	..()
	block=TOXICFARTBLOCK

//////////////////
// USELESS SHIT //
//////////////////

// WAS: /datum/bioEffect/strong
/datum/dna/gene/disability/strong
	// pretty sure this doesn't do jack shit, putting it here until it does
	name = "Forte"
	desc = "Melhora a capacidade do sujeito de construir e reter músculos pesados."
	activation_message = "Você se sente melhorado!"
	deactivation_message = "Você se sente mal e fraco."
	mutation = STRONG

/datum/dna/gene/disability/strong/New()
	..()
	block=STRONGBLOCK

// WAS: /datum/bioEffect/horns
/datum/dna/gene/disability/horns
	name = "Chifres"
	desc = "Permite o crescimento de uma formação de queratina compactada na cabeça do sujeito."
	activation_message = "Um par de chifres surge em sua cabeça."
	deactivation_message = "Seus chifres se cairam derrepente."
	mutation = HORNS

/datum/dna/gene/disability/horns/New()
	..()
	block=HORNSBLOCK

/datum/dna/gene/disability/horns/OnDrawUnderlays(var/mob/M,var/g,var/fat)
	return "horns_s"

////////////////////////////////////////////////////////////////////////
// WAS: /datum/bioEffect/immolate
/datum/dna/gene/basic/grant_spell/immolate
	name = "Mitochondria Incendiária"
	desc = "O sujeito torna-se capaz de converter o excesso de energia celular em energia térmica."
	activation_messages = list("De repente você se sente bastante quente.")
	deactivation_messages = list("Você não se sente desconfortavelmente quente.")
	mutation = IMMOLATE

	spelltype=/obj/effect/proc_holder/spell/targeted/immolate

/datum/dna/gene/basic/grant_spell/immolate/New()
	..()
	block = IMMOLATEBLOCK

/obj/effect/proc_holder/spell/targeted/immolate
	name = "Mitochondria Incendiária"
	desc = "O sujeito torna-se capaz de converter o excesso de energia celular em energia térmica."
	panel = "Abilities"

	charge_type = "recharge"
	charge_max = 600

	clothes_req = 0
	stat_allowed = 0
	invocation_type = "none"
	range = -1
	selection_type = "range"
	var/list/compatible_mobs = list(/mob/living/carbon/human)
	include_user = 1

	action_icon_state = "genetic_incendiary"

/obj/effect/proc_holder/spell/targeted/immolate/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/L = user
	L.adjust_fire_stacks(0.5)
	L.visible_message("<span class='danger'>[L.name]</b> subitamente entrou em combustão!</span>")
	L.IgniteMob()
	playsound(L.loc, 'sound/effects/bamf.ogg', 50, 0)
