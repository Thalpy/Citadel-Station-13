#define FRIENDLY_THRESHOLD 50
//Battle code
/obj/culture/proc/prepBattle()
    favouredStat = determinePrimaryStat()
    cached_stats = list("strength" = strength, "intelligence" = intelligence, "agility" = agility, "charisma" = charisma)

/obj/culture/proc/Battle()
    var/current_turn = 1
    var/friendliness = 0
    var/RNG
    var/combat_message
    var/status_effects = list()
    inGloriousCombat = TRUE

    prepBattle()

//Helper functions
//Find the largest stat
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

//calc randomness
/obj/culture/proc/RNGCalc(obj/culture/C)
    var/RNG = rand(0, 1, 0.01)
    var/cached_luck = C.luck/5
    //lucky organs get multi rolls
    while(cached_luck>1)
        var/tRNG = rand(0, 1, 0.01)
        if(tRNG > RNG)
            RNG = tRNG
        cached_luck -= 1
    return RNG

//limit fatique
/obj/culture/proc/adjust_fatique(amount)
    fatique += amount
    if(fatique > 20)
        fatique = 20
        return TRUE
    return FALSE

/obj/culture/proc/process_statuses()
    if(!LAZYLEN(status_effects))
        return
    for(var/status in status_effects)
        switch(status)
            if("poison")
                deal_damage(status_effects[status])

/obj/culture/proc/damage_calc(obj/culture/target)//Calculate damage
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

    //being tired makes you do less damage
    damage = damage * (fatique/20)


    if(RNGCalc >= 0.95)//Crits!
        if(favouredStat == "strength")
            damage *= 2
        else
            damage *= 1.5
    return damage

/obj/culture/proc/defend(obj/culture/attacker, damage, accuracy) //Calculate received damage and dodge chance
    RNG = RNGCalc(src)

    if(favouredStat == "intelligence")
        if(RNG >= 0.9)
            combat_message = "[src] foresee's [attacker]'s attack, and dodges!'"
            return FALSE

    //dodge checks
    var/dodge = (agility * ((luck / 5) * RNG)))/2
    if(favouredStat == "agility")//Agile organs have higher dodge
        dodge *= 1.2
    if(dodge > accuracy)
        combat_message = "[src] dances majestically around [attacker]'s attack, and dodges!'"
        return FALSE

    //defence calcs
    var/defence = (strength * ((luck / 5) * RNG)))
    if(favouredStat == "strength") //Strengths have higher defence
        defence *= 1.2

    //Armor pen (flat int)
    var/armorPen = defence/100
    if(attacker.favouredStat == "intelligence")
        armorPen = armorPen * ((accuracy * attacker.intelligence))
    else
        armorPen = armorPen * ((accuracy * attacker.intelligence)/1.3)
    defence -= armorPen

    //Charisma deminishes over time
    else if(favouredStat == "charisma")
        damage /= (1 - (current_turn / 20))
    damage = damage - defence
    if(damage < 0)
        combat_message = "[src] blocks [attacker]'s attack!'"
        return FALSE

    //end
    return damage

/obj/culture/proc/deal_damage(amount)
    health -= amount
    to_local_chat("[name] takes [amount] damage!")
    if(health < 0)
        defeat()

/obj/culture/proc/heal(amount)
    health += amount
    to_local_chat("[name] heals for [amount]!")
    if(health > maxHealth)
        health = maxHealth

/obj/culture/proc/friendly_damage(amount)
    friendliness += amount
    to_local_chat("[name] is swayed by [amount]!")
    if(friendliness > FRIENDLY_THRESHOLD)
        make_friends()
        return


/obj/culture/proc/prep_spell(datum/culture_traits/spell1, datum/culture_traits/spell2, obj/culture/target)
    //charisma gets 2 spells at once
    //incase of no spells picked (say a nother spell causes this) 2 are picked randomly from the avalible
    if(!spell1)
        spell1 = pick(trait)
    if(!spell2 && favouredStat == "charisma")
        spell2 = pick(trait)

    //spell power calculations are flat for now, maybe I'll make it more int dependant based on balance/meta
    var/spellPower = 1
    if(favouredStat == "intelligence")
        spellPower = 1.5
    spellPower += RNGCalc(src)
    cast_spell(spell, spellPower)

    //Agile organs incurr less fatique
    if(favouredStat == "agility")
        adjust_fatique(2.5)
    else
        adjust_fatique(4)

    //cast the spell, or both, if charismatic
    spell1.spell(src, target)
    if(favouredStat == "charisma")
        spell2.spell(src, target)




/obj/culture/proc/cast_spell(spell, var/spellPower, var/obj/culture/target)

    //Probabbly just make the traits themselves run a script
