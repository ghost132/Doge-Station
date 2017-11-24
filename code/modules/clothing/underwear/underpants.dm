/obj/item/clothing/underwear/underpants
	var/adjustable = 0
	var/adjusted = 0

/obj/item/clothing/underwear/underpants/verb/adjust()
	set name = "Adjust Underwear"
	set category = "Object"
	set src in view(1)

	var/mob/living/carbon/human/H = usr

	if(!istype(H) || H.incapacitated())
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(H.get_item_by_slot(slot_underpants) != src)
		return

	if(adjustable)
		adjusted = !adjusted
		if(adjusted)
			to_chat(H, "<span class='notice'>You pull [src] aside.</span>")
		else
			to_chat(H, "<span class='notice'>You put [src] back in place.</span>")
	else
		to_chat(H, "<span class='warning'>You can't ajust this underwear.</span>")

/obj/item/clothing/underwear/underpants/dropped(mob/user)
	..()
	adjusted = 0

/obj/item/clothing/underwear/underpants/New()
	..()
	icon_state = "uw_[icon_state]_s"

/obj/item/clothing/underwear/underpants/nude
	name = "Nude"

/obj/item/clothing/underwear/underpants/nude/New()
	..()
	icon_state = "nude"

/obj/item/clothing/underwear/underpants/male_white
	name = "Cueca Branca"
	icon_state = "male_white"
	item_state = "lgloves"

/obj/item/clothing/underwear/underpants/male_grey
	name = "Cueca Cinza"
	icon_state = "male_grey"
	item_state = "bgloves"

/obj/item/clothing/underwear/underpants/male_grey
	name = "Cueca Cinza Alt"
	icon_state = "male_greyalt"
	item_state = "bgloves"

/obj/item/clothing/underwear/underpants/male_green
	name = "Cueca verde"
	icon_state = "male_green"
	item_state = "bgloves"

/obj/item/clothing/underwear/underpants/male_blue
	name = "Cueca Azul"
	icon_state = "male_blue"
	item_state = "bgloves"

/obj/item/clothing/underwear/underpants/male_red
	name = "Cueca Vermelha"
	icon_state = "male_red"
	item_state = "r_shoes"

/obj/item/clothing/underwear/underpants/male_black
	name = "Cueca Preta"
	icon_state = "male_black"
	item_state = "bgloves"

/obj/item/clothing/underwear/underpants/male_black_alt
	name = "Cueca Preta Alt"
	icon_state = "male_blackalt"
	item_state = "bgloves"

/obj/item/clothing/underwear/underpants/male_striped
	name = "Mens Striped"
	icon_state = "male_stripe"
	item_state = "bl_shoes"

/obj/item/clothing/underwear/underpants/male_heart
	name = "Boxer de Coraçao"
	icon_state = "male_hearts"
	item_state = "r_shoes"

/obj/item/clothing/underwear/underpants/male_kinky
	name = "Mens Kinky"
	icon_state = "male_kinky"
	item_state = "bgloves"

/obj/item/clothing/underwear/underpants/male_mankini
	name = "Mankini"
	icon_state = "male_mankini"
	item_state = "bgloves"

/obj/item/clothing/underwear/underpants/female_red
	name = "Calcinha Vermelha"
	icon_state = "female_red"
	item_state = "r_shoes"
	adjustable = 1
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_green
	name = "Calcinha Verde"
	icon_state = "female_green"
	item_state = "bgloves"
	adjustable = 1
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_white
	name = "Calcinha Branca"
	icon_state = "female_white"
	item_state = "lgloves"
	adjustable = 1
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_whiter
	name = "Calcinha Brancar" //o R ta no nome original
	icon_state = "female_whiter"
	item_state = "lgloves"
	adjustable = 1
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_whitealt
	name = "Calcinha Branca Alt"
	icon_state = "female_whitealt"
	item_state = "lgloves"
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_yellow
	name = "Ladies Yellow"
	icon_state = "female_yellow"
	item_state = "o_shoes"
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_blue
	name = "Calcinha Azul"
	icon_state = "female_blue"
	item_state = "bgloves"
	adjustable = 1
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_babyblue
	name = "Calcinha Azul Bebe"
	icon_state = "female_babyblue"
	item_state = "bgloves"
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_black
	name = "Calcinha Preta" //Soo hot
	icon_state = "female_black"
	item_state = "bgloves"
	adjustable = 1
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_blacker
	name = "Calcinha Negra"
	icon_state = "female_blacker"
	adjustable = 1
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_blackalt
	name = "Calcinha Preta Alt"
	icon_state = "female_blackalt"
	item_state = "bgloves"
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_kinky
	name = "Ladies Kinky"
	icon_state = "female_kinky"
	item_state = "r_shoes"
	adjustable = 1
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_babydoll
	name = "Calcinha Cinza Cheio"
	icon_state = "female_babydoll"
	item_state = "bgloves"
	adjustable = 1
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_pink
	name = "Calcinha Rosa"
	icon_state = "female_pink"
	item_state = "r_shoes"
	flags_inv = HIDEBREASTS

/obj/item/clothing/underwear/underpants/female_thong
	name = "Ladies Thong"
	icon_state = "female_thong"
	item_state = "r_shoes"
	adjustable = 1
	flags_inv = HIDEBREASTS
