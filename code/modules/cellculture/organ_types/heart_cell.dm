/datum/culture/heart/hardened
    name = "Dwarven heart"
    minSTR = 8
    required_predecesor = "heart"
    required_traits = /datum/culture_traits/alcoholic
    rarity = UNCOMMON
    merge_text = "You feel a lot smaller, and like you've a few unsettled grudges."
    remove_text = "You think you can find it in your heart to forgive again."

/datum/culture/heart/hardened/on_insertion(mob/living/carbon/human/body, obj/culture/target)
    ADD_TRAIT(body, TRAIT_ANTIMAGIC, "dwarf_heart")
    ADD_TRAIT(body, TRAIT_NOCLONE, "dwarf_heart")
    C.dna.add_mutation(DWARFISM)
    C.maxHealth += 10
    ..()

/datum/culture/heart/hardened/on_removal(mob/living/carbon/human/body, obj/culture/target)
    REMOVE_TRAIT(body, TRAIT_ANTIMAGIC, "dwarf_heart")
    REMOVE_TRAIT(body, TRAIT_NOCLONE, "dwarf_heart")
    C.dna.remove_mutation(DWARFISM)
    C.maxHealth -= 10
    ..()
