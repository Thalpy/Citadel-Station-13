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

/obj/culture/proc/to_local_chat(words)
    var/list/seen = viewers(7, get_turf(src))
    var/iconhtml = icon2html(src, seen)
    for(var/mob/M in seen)
        to_chat(M, "<span class='notice'>[iconhtml] [words]</span>")

/obj/culture/process()
    //do the thing! thanks
