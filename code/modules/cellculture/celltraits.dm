//Stealing from reagent code? Nooooo
/proc/build_tamitraits_list()

    if(GLOB.tamitraits_list)
        return

    var/paths = subtypesof(/datum/culture_traits)
    GLOB.tamitraits_list = list()

    for(var/path in paths)
        var/datum/culture/D = new path()
        GLOB.tamitrait_list[path] = D


datum/culture_traits
    var/name

datum/culture_traits/New()
    build_tamitraits_list()

datum/culture_traits/proc/spell(obj/culture/self, obj/culture/target)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


datum/culture_traits/alcoholic
    name = "alcoholic"

datum/culture_traits/alcoholic/spell(obj/culture/self, obj/culture/target)
    var/damage = self.damage_calc(target)
    self.to_local_chat("[self] offers [target] a drink!")

    if(target.has_cell_trait(datum/culture_traits/alcoholic))
        target.heal(damage)
        target.friendly_damage(damage)
        self.to_local_chat("The two organs bond together from their love of alcohol.")
        return

    if(target.type == "liver")
        damage *= 1.2

    damage /= 5
    target.status_effects["poison"] += damage
    self.to_local_chat("[target] takes a sip of the drink, oof, they're a bit of a lightweight!")
