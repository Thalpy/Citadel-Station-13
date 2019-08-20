//Stealing from reagent code? Nooooo
/proc/build_tamitraits_list()

    if(GLOB.tamitraits_list)
        return

    var/paths = subtypesof(/datum/culture_traits)
    GLOB.tamitraits_list = list()

    for(var/path in paths)
        var/datum/culture/D = new path()
        GLOB.tamitrait_list[path] = D


/datum/culture_traits
    var/name
    var/randomlyAcquired = TRUE
    var/requiredStats


/datum/culture_traits/New()
    build_tamitraits_list()

/datum/culture_traits/proc/spell(obj/culture/self, obj/culture/target)//Spells used in combat

/datum/culture_traits/proc/on_growth(obj/culture/self)//When an organ advances in age TODO

/datum/culture_traits/proc/life_tick(obj/culture/self)//For each processing tick TODO

/datum/culture_traits/proc/on_gain(obj/culture/self)//When a trait is added to a tamiorgan TODO

/datum/culture_traits/proc/on_removal(obj/culture/self)//When a trait is removed from a tamiorgan TODO

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/datum/culture_traits/alcoholic
    name = "alcoholic"
    randomlyAquired = FALSE

/datum/culture_traits/alcoholic/spell(obj/culture/self, obj/culture/target, spellPower)
    self.to_local_chat("[self] offers [target] a drink!")

    if(target.has_cell_trait(datum/culture_traits/alcoholic))
        target.heal(spellPower)
        target.friendly_damage(spellPower)
        self.to_local_chat("The two organs bond together from their love of alcohol.")
        self.happiness++
        target.happiness++
        return

    if(target.type == "liver" && target.status_effects["drunk"])
        spellPower *= 1.2

    if(target.status_effects["drunk"] >= 3)
        spellPower /= 5
        target.status_effects["poison"] = (target.status_effects["poison"]? (target.status_effects["poison"] + (spellPower/2)) : spellPower)
        self.to_local_chat("[target] takes another drink, and stumbles, goodness, they're smashed!")
        return

    else
        target.status_effects["drunk"] + 1

/datum/culture_traits/alcoholic/on_gain(obj/culture/self)
    self.adjust_cell_stats(-1, "intelligence")

/datum/culture_traits/alcoholic/on_removal(obj/culture/self)
    self.adjust_cell_stats(1, "intelligence")

/datum/culture_traits/alcoholic/life_tick(obj/culture/self)
