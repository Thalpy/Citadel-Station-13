//Handheld culture
#define C_DEAD 0
#define C_BABY 1
#define C_YOUTH 2
#define C_ADOLESENT 3
#define C_YOUNG_ADULT 4
#define C_ADULT 5

/obj/culture
    var/maxHealth = 50
    var/health = 50
    var/happiness = 50
    var/intelligence = 0
    var/strength = 0
    var/agility = 0
    var/charisma = 0
    var/luck = 0
    var/nutrition = 20
    var/fatique = 0 //20 is max for now
    var/traits = list()//A list of stuff organs can pick up from exposing them to certain behavours
    var/name = "Humsquanch babnorp"
    var/age = C_BABY
    var/type = "Stem cells"
    //datums
    /datum/culture
    //Combat vars
    var/cached_stats
    var/favouredStat
    var/attackPhrase = "bloody well punches the other organ! I say!"
    var/inGloriousCombat = FALSE //Prevent people from taking their organs when dueling

/obj/culture/Initialize()
	. = ..()
	create_reagents(50)//For heat and feeding

    reagents = new/datum/reagents(max_vol, flags)
	reagents.my_atom = src
    var/datum/thing

/obj/culture/proc/has_cell_trait(datum/culture_traits/Ct)
    for(var/datum/culture_trait/trait in traits)
        if(Ct == trait)
            return TRUE
    return FALSE

/obj/culture/proc/to_local_chat(words)//Displays a lil cute organ to everyone in a 7 tile square diameter
    var/list/seen = viewers(7, get_turf(src))
    var/iconhtml = icon2html(src, seen)
    for(var/mob/M in seen)
        to_chat(M, "<span class='notice'>[iconhtml] [words]</span>")

//simple check to make sure it doesn't go below 0
/obj/culture/proc/adjust_cell_stats(amount, type)
    switch(type)

        if("strength")
            strength += amount
            if(strength < 0)
                strength = 0
            return TRUE

        if("intelligence")
            intelligence += amount
            if(intelligence < 0)
                intelligence = 0
            return TRUE

        if("agility")
            agility += amount
            if(agility < 0)
                agility = 0
            return TRUE

        if("charisma")
            charisma += amount
            if(charisma < 0)
                charisma = 0
            return TRUE

        if("luck")
            luck += amount
            if(luck < 0)
                luck = 0
            return TRUE

    stack_trace("TAMIORGANS: Tried to modify a non existant stat: [type]!")
    return FALSE


/obj/culture/process()
    //do the thing! thanks
