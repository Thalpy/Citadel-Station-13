#define COMMON 3
#define UNCOMMON 2
#define RARE 1

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//datum/culture - USED ONLY FOR ORGAN EFFECTS. SEE TRAITS FOR GROWTH EFFECTS.
//This is esstentially split into two, so that there isn't a bunch of extra stuff when growing and matured.
//Procs to care about: on_insertion(), life_tick(), on_removal()
//You can set up actions too, but they need to use the organ_action datum. It's recommend that you keep organ_actions in the same .dm as datum/cultures you make
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
/datum/culture
    var/name //Maybe unnessicary
    var/minSTR = 0 //minimum strength required
    var/minINT = 0  //ect
    var/minAGIL = 0
    var/minCHAR = 0
    var/minLUCK = 0
    var/age //C_BABY, C_YOUTH, C_ADOLESENT, C_YOUNG_ADULT, C_ADULT of the TARGET, i.e. the obj/culture will have to be a C_YOUNG_ADULT and this will have to be a C_ADULT to become it.
    var/required_predecesor //either a specific name, or  specific type, i.e. alcoholiver or liver
    var/required_traits = list() //Required traits to create this organ
    var/rarity = COMMON //How rare something is, COMMON, UNCOMMON or RARE
    var/list/datum/culture/culture_list = new/list() //I honestly forgot what this is for? I don't think I use it. Consider removal upon final review.
    var/actions_types //eg; list(/datum/action/item_action/organ_action/cursed_heart)

/datum/culture/New()
    build_tamiorgan_list()

/datum/culture/proc/on_insertion(mob/living/carbon/human/body, obj/culture/target) //When inserted into a human

/datum/culture/proc/life_tick(mob/living/carbon/human/body, obj/culture/target)//procs every life tick


//To set up actions for a tamiorgan, use the following typepath, see their example for more details.
//datum/action/item_action/organ_action/example
//target = /obj/item/organ/ect, var/mob/living/carbon/human/H = owner
//icon will default to organ icon, look into datum/action code for more details/avalible vars

//Put the actual code here:
//datum/action/item_action/organ_action/example/Trigger()

/datum/culture/proc/on_removal(mob/living/carbon/human/body, obj/culture/target) //When removed from a human

//needs testing
//used to figure out what a growing tamiorgan will become.
//Checks age, checks to see if the current organ type OR name is the same as the prerequired one defined
//Then checks stats, and finally checks the traits required.
//Then it builds a list, with COMMON having 3 entries, UNCOMMON having 2, and RARE having 1. Then picks one from the list.
//Thus, if you want a specific one, it can be worth growing it to exclude the most.
/datum/culture/proc/determine_growth_candidates(/obj/culture/C)
    if(C.age == C_ADULT)//Adults can't grow!
        return FALSE

    var/list/cached_tami_list = GLOB.tamiorgan_list
    var/list/possible_tamiorgans = list()


    for(var/datum/culture/candidate in cached_tami_list)
        var/candidate_pass = TRUE
        //Check to see if it is age appropriate
        if(C.age+1 != candidate.age)
            continue

        //Check to see if current stage is the predecessor to the next,
        if(candidate.required_predecesor)
            if(candidate.required_predecesor != C.name || candidate.required_predecesor != C.type)
                continue

        //Check stats vs potential
        if(candidate.minSTR > C.strength)
            continue
        if(candidate.minINT > C.intelligence)
            continue
        if(candidate.minAGIL > C.agility)
            continue
        if(candidate.minCHAR > C.charisma)
            continue
        if(candidate.minLUCK > C.luck)
            continue

        //check traits
        for(var/datum/trait in candidate.required_traits)
            if(C.has_cell_trait(trait))
                continue
            else
                candidate_pass = FALSE //To make sure that this WORKS

        if(candidate_pass)
            possible_tamiorgans += candidate

    if(!possible_tamiorgans)
        return

    //create a weighted list of rarities
    var/list/possible_rarity_tamiorgans
    for(var/datum/culture/candidate in possible_tamiorgans)
        for(var/i in 1 to candidate.rarity)
            possible_rarity_tamiorgans += candidate

    //And we're done!
    return pick(possible_rarity_tamiorgans)
