//Battle code
/obj/culture/proc/prepBattle()
    favouredStat = determinePrimaryStat()
    cached_stats = list("strength" = strength, "intelligence" = intelligence, "agility" = agility, "charisma" = charisma)

/obj/culture/proc/Battle()
    var/current_turn = 1
    var/RNG
    var/combat_message
    inGloriousCombat = TRUE

    prepBattle()

/obj/culture/proc/RNGCalc(var/obj/culture/C)
    var/RNG = rand(0, 1, 0.01)
    var/cached_luck = C.luck/5

    //lucky organs get 2 rolls
    while(cached_luck>1)
        var/tRNG = rand(0, 1, 0.01)
        if(tRNG > RNG)
            RNG = tRNG
        cached_luck -= 1

    return RNG

/obj/culture/proc/attack(var/obj/culture/target)
    RNG = RNGCalc(src)

    //Just in case
    if(!favouredStat)
        favouredStat = determinePrimaryStat()

    var/damage
    switch(favouredStat)//Haha like this is balanced at all, I just enjoy chaos

        if("strength")
            damage = (1.15 * strength + ((luck / 5) * RNG)) //Strength gains a 1.15 bonus to attacks

        if("intelligence")
            damage = (intelligence + ((luck / 3) * RNG)) //Intelligence makes your luck slightly more effective

        if("agility")//can multihit up to 2.1x !!
            var/basedam = 0.6
            var/multihitC = 1
            damage = (basedam * agility + ((luck / 5) * RNG))
            if(prob((50 + luck/5)) && basedam > 0.11)
                basedam -= 0.1
                damage += (basedam * agility + ((luck / 5) * RNG))
                multihitC++

        if("charisma")//Charisma gains strength over the battle

            damage = (0.8 + (current_turn / 10) * charisma * ((luck / 5) * RNG))

        damage = damage * (fatique/20)//

/obj/culture/proc/defend(var/obj/culture/attacker, var/damage, var/accuracy)
    RNG = RNGCalc(src)

    if(favouredStat == "intelligence")
        if(RNG >= 0.9)
            combat_message = "[src] foresee's [attacker]'s attack, and dodges!'"
            return FALSE

    var/dodge = (agility * ((luck / 5) * RNG)))/2
    if(favouredStat == "agility")
        dodge *= 1.2
    if(dodge > accuracy)
        combat_message = "[src] dances majestically around [attacker]'s attack, and dodges!'"
        return FALSE

    var/defence = (strength * ((luck / 5) * RNG)))/2
    if(favouredStat == "strength")
        defence *= 1.2
    if(favouredStat == "charisma")
        damage /= (1 - (current_turn / 20))
    damage = damage - defence
    if(damage < 0)
        combat_message = "[src] blocks [attacker]'s attack!'"
        return FALSE

    return damage


/obj/culture/proc/determinePrimaryStat()//Lemme know if theres a better way to do this
    if(strength == max(list(strength, intelligence, agility, charisma))
        return "strength"
    if(intelligence == max(list(strength, intelligence, agility, charisma))
        return "intelligence"
    if(agility == max(list(strength, intelligence, agility, charisma))
        return "agility"
    if(charisma == max(list(strength, intelligence, agility, charisma))
        return "charisma"
    return FALSE
