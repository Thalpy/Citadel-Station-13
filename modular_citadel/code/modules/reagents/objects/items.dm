/obj/item/pHbooklet
    name = "pH indicator booklet"
    desc = "A booklet containing paper soaked in universal indicator."
    icon_state = "pHbooklet"
    icon = 'modular_citadel/icons/obj/FermiChem.dmi'
    item_flags = NOBLUDGEON
    var/numberOfPages = 50
    resistance_flags = FLAMMABLE
    w_class = WEIGHT_CLASS_TINY
    //set flammable somehow

/obj/item/pHbooklet/attack_hand(mob/user)
	if(user.get_held_index_of_item(src))
		if(numberOfPages >= 1)
			var/obj/item/pHpaper/P = new /obj/item/pHpaper
			P.add_fingerprint(user)
			P.forceMove(user.loc)
			user.put_in_active_hand(P)
			to_chat(user, "<span class='notice'>You take [P] out of \the [src].</span>")
			numberOfPages--
			playsound(user.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			add_fingerprint(user)
			return
		else
			to_chat(user, "<span class='warning'>[src] is empty!</span>")
			add_fingerprint(user)
			return
    ..()
	var/I = user.get_active_held_item()
	if(!I)
		user.put_in_active_hand(src)
	return

/obj/item/pHpaper
    name = "pH indicator strip"
    desc = "A piece of paper that will change colour depending on the pH of a solution."
    icon_state = "pHpaper"
    icon = 'modular_citadel/icons/obj/FermiChem.dmi'
    //item_flags = NOBLUDGEON
    color = "#f5c352"
    var/used = FALSE
    resistance_flags = FLAMMABLE
    w_class = WEIGHT_CLASS_TINY
    //set flammable somehow

/obj/item/pHpaper/afterattack(obj/item/reagent_containers/cont, mob/user, proximity)
    if(!istype(cont))
        return
    if(used == TRUE)
        to_chat(user, "<span class='warning'>[user] has already been used!</span>")
        return
    switch(cont.reagents.pH)
        if(14 to INFINITY)
            color = "#462c83"
        if(13 to 14)
            color = "#63459b"
        if(12 to 13)
            color = "#5a51a2"
        if(11 to 12)
            color = "#3853a4"
        if(10 to 11)
            color = "#3f93cf"
        if(9 to 10)
            color = "#0bb9b7"
        if(8 to 9)
            color = "#23b36e"
        if(7 to 8)
            color = "#3aa651"
        if(6 to 7)
            color = "#4cb849"
        if(5 to 6)
            color = "#b5d335"
        if(4 to 5)
            color = "#f7ec1e"
        if(3 to 4)
            color = "#fbc314"
        if(2 to 3)
            color = "#f26724"
        if(1 to 2)
            color = "#ef1d26"
        if(-INFINITY to 1)
            color = "#c6040c"
    desc += " The paper looks to be around a pH of [round(cont.reagents.pH)]"
    used = TRUE
