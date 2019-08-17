//Build a list of the entries so we can grab them later
/proc/build_tamiorgan_list()

    if(GLOB.tamiorgan_list)
        return

    var/paths = subtypesof(/datum/culture)
    GLOB.tamiorgan_list = list()

    for(var/path in paths)
        var/datum/culture/D = new path()
        GLOB.tamiorgan_list[path] = D

//contains a datum of all possible tamiorgans
//mostly used to figure out what they grow into
datum/culture
    var/name
    var/minSTR
    var/minINT
    var/minAGIL
    var/minCHAR
    var/minLUCK
    var/age
    var/required_traits = list()
    var/list/datum/culture/culture_list = new/list()

datum/culture/New()
    build_tamiorgan_list()

datum/culture/proc/on_insertion(mob/living/carbon/human/body, obj/culture/target)

datum/culture/proc/life_tick(mob/living/carbon/human/body, obj/culture/target)

datum/culture/proc/activate(mob/living/carbon/human/body, obj/culture/target)

datum/culture/proc/on_removal(mob/living/carbon/human/body, obj/culture/target)


datum/culture/proc/determine_growth_candidates(/obj/culture/C)
    if(C.age == C_ADULT)//Adults can't grow!
        return FALSE


    if(minSTR)
