/datum/status_effect/chem/SGDF
	id = "SGDF"
	var/mob/living/fermi_Clone
	alert_type = null

/*
/obj/screen/alert/status_effect/SDGF
	name = "SDGF"
	desc = "You've cloned yourself! How cute."
	icon_state = "SDGF"
*/

/datum/status_effect/chem/SGDF/on_apply()
	message_admins("SGDF status appied")
	var/typepath = owner.type
	fermi_Clone = new typepath(owner.loc)
	var/mob/living/carbon/M = owner
	var/mob/living/carbon/C = fermi_Clone

	//fermi_Clone = new typepath(get_turf(M))
	//var/mob/living/carbon/C = fermi_Clone
	//var/mob/living/carbon/SM = fermi_Gclone

	if(istype(C) && istype(M))
		C.real_name = M.real_name
		M.dna.transfer_identity(C, transfer_SE=1)
		C.updateappearance(mutcolor_update=1)
	return ..()

/datum/status_effect/chem/SGDF/tick()
	//message_admins("SDGF ticking")
	if(owner.stat == DEAD)
		//message_admins("SGDF status swapping")
		if((fermi_Clone && fermi_Clone.stat != DEAD) || (fermi_Clone == null))
			if(owner.mind)
				owner.mind.transfer_to(fermi_Clone)
				owner.visible_message("<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
				fermi_Clone.visible_message("<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
				fermi_Clone = null
				owner.remove_status_effect(src)
		//	to_chat(owner, "<span class='notice'>[linked_extract] desperately tries to move your soul to a living body, but can't find one!</span>")
	..()

/datum/status_effect/chem/BElarger
	id = "BElarger"
	alert_type = null
	var/moveCalc = 1
	//var/breast_values 		= list ("a" =  1, "b" = 2, "c" = 3, "d" = 4, "e" = 5, "f" = 6, "g" = 7, "h" = 8, "i" = 9, "j" = 10, "k" = 11, "l" = 12, "m" = 13, "n" = 14, "o" = 15, "huge" = 16, "flat" = 0)
	//var/list/items = list()
	//var/items = o.get_contents()

//mob/living/carbon/M = M tried, no dice
//owner, tried, no dice
/datum/status_effect/chem/BElarger/on_apply(mob/living/carbon/human/H)//Removes clothes, they're too small to contain you. You belong to space now.
	var/mob/living/carbon/human/o = owner
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			to_chat(o, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling breasts! Unless you manage to reduce the size of your breasts, there's no way you're going to be able to put anything on over these melons..!</b></span>")
			o.visible_message("<span class='boldnotice'>[o]'s chest suddenly bursts forth, ripping their clothes off!'</span>")
	//message_admins("BElarge started!")
		else
			to_chat(o, "<span class='notice'>Your bountiful bosom is so rich with mass, you seriously doubt you'll be able to fit any clothes over it.</b></span>")
		return ..()

/datum/status_effect/chem/BElarger/tick(mob/living/carbon/human/H)//If you try to wear clothes, you fail. Slows you down if you're comically huge
	var/mob/living/carbon/human/o = owner
	var/obj/item/organ/genital/breasts/B = o.getorganslot("breasts")
	moveCalc = 1+((round(B.cached_size) - 9)/10) //Afffects how fast you move, and how often you can click.
	if(!B)
		o.remove_movespeed_modifier("megamilk")
		o.next_move_modifier /= moveCalc
		owner.remove_status_effect(src)
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			to_chat(owner, "<span class='warning'>Your enormous breasts are way too large to fit anything over them!</b></span>")
	if (B.breast_values[B.size] > B.breast_values[B.prev_size])
		o.add_movespeed_modifier("megamilk", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = moveCalc)
		o.next_move_modifier *= moveCalc
	else if (B.breast_values[B.size] < B.breast_values[B.prev_size])
		o.add_movespeed_modifier("megamilk", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = moveCalc)
		o.next_move_modifier /= moveCalc
	if(round(B.cached_size) < 16)
		switch(round(B.cached_size))
			if(9)
				if (!(B.breast_sizes[B.prev_size] == B.size))
					to_chat(o, "<span class='notice'>Your expansive chest has become a more managable size, liberating your movements.</b></span>")
			if(10 to INFINITY)
				if (!(B.breast_sizes[B.prev_size] == B.size))
					to_chat(H, "<span class='warning'>Your indulgent busom is so substantial, it's affecting your movements!</b></span>")
		if(prob(5))
			to_chat(H, "<span class='notice'>Your back is feeling a little sore.</b></span>")
		..()

/datum/status_effect/chem/BElarger/on_remove(mob/living/carbon/M)
	owner.remove_movespeed_modifier("megamilk")
	owner.next_move_modifier /= moveCalc


/datum/status_effect/chem/PElarger
	id = "PElarger"
	alert_type = null
	var/bloodCalc
	var/moveCalc

/datum/status_effect/chem/PElarger/on_apply(mob/living/carbon/human/H)//Removes clothes, they're too small to contain you. You belong to space now.
	message_admins("PElarge started!")
	var/mob/living/carbon/human/o = owner
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	if(o.w_uniform || o.wear_suit)
		to_chat(o, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling pecker! Unless you manage to reduce the size of your emancipated trouser snake, there's no way you're going to be able to put anything on over this girth..!</b></span>")
		owner.visible_message("<span class='boldnotice'>[o]'s schlong suddenly bursts forth, ripping their clothes off!'</span>")
	else
		to_chat(o, "<span class='notice'>Your emancipated trouser snake is so ripe with girth, you seriously doubt you'll be able to fit any clothes over it.</b></span>")
	return ..()


/datum/status_effect/chem/PElarger/tick(mob/living/carbon/M)
	var/mob/living/carbon/human/o = owner
	var/obj/item/organ/genital/penis/P = o.getorganslot("penis")
	moveCalc = 1+((round(P.length) - 21)/10) //effects how fast you can move
	bloodCalc = 1+((round(P.length) - 21)/10) //effects how much blood you need (I didn' bother adding an arousal check because I'm spending too much time on this organ already.)
	if(!P)
		o.remove_movespeed_modifier("hugedick")
		o.blood_ratio /= bloodCalc //If someone else uses blood_ratio, turn this into a multiplier(I should make a handler huh)
		owner.remove_status_effect(src)
	message_admins("PElarge tick!")
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			to_chat(owner, "<span class='warning'>Your enormous package is way to large to fit anything over!</b></span>")
	switch(round(P.cached_length))
		if(21)
			if (P.prev_size > P.size)
				to_chat(o, "<span class='notice'>Your rascally willy has become a more managable size, liberating your movements.</b></span>")
				o.remove_movespeed_modifier("hugedick")
				o.blood_ratio /= bloodCalc
		if(22 to INFINITY)
			if (!(P.prev_size == P.size))
				to_chat(o, "<span class='warning'>Your indulgent johnson is so substantial, it's taking all your blood and affecting your movements!</b></span>")
				o.add_movespeed_modifier("hugedick", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = moveCalc)
				o.blood_ratio *= bloodCalc
	..()

/datum/status_effect/chem/PElarger/on_remove(mob/living/carbon/human/o)
	owner.remove_movespeed_modifier("hugedick")
	o.blood_ratio /= bloodCalc


/*//////////////////////////////////////////
		Mind control functions
///////////////////////////////////////////
*/

//Preamble
/mob/living
	var/lewd = TRUE //Maybe false?

/mob/living/verb/toggle_lewd()
	set category = "IC"
	set name = "Toggle Lewdchem"
	set desc = "Allows you to toggle if you'd like lewd flavour messages."
	lewd = !(lewd)
	to_chat(usr, "You [(lewd?"will":"no longer")] receive lewdchem messages.")

/datum/status_effect/chem/enthrall
	id = "enthrall"
	alert_type = null
	var/mob/living/E //E for enchanter
	//var/mob/living/V = list() //V for victims
	var/enthrallTally = 1 //Keeps track of the enthralling process
	var/resistanceTally = 0 //Keeps track of the resistance
	var/deltaResist //The total resistance added per resist click
	//var/deltaEnthrall //currently unused (i think)
	var/phase = 1 //-1: resisted state, due to be removed.0: sleeper agent, no effects unless triggered 1: initial, 2: 2nd stage - more commands, 3rd: fully enthralled, 4th Mindbroken
	var/status = null //status effects
	var/statusStrength = 0 //strength of status effect
	var/mob/living/master //Enchanter's person
	var/enthrallID //Enchanter's ckey
	var/enthrallGender //Use master or mistress
	//var/mob/living/master == null
	var/mental_capacity //Higher it is, lower the cooldown on commands, capacity reduces with resistance.
	//var/mental_cost //Current cost of custom triggers
	//var/mindbroken = FALSE //Not sure I use this, replaced with phase 4
	var/datum/weakref/redirect_component //resistance
	//var/datum/weakref/redirect_component2 //say
	//var/datum/weakref/redirect_component3 //hear
	var/distancelist = list(2,1.5,1,0.8,0.6,0.5,0.4,0.3,0.2) //Distance multipliers
	var/withdrawal = FALSE //withdrawl
	var/withdrawalTick = 0 //counts how long withdrawl is going on for
	var/list/customTriggers = list() //the list of custom triggers (maybe have to split into two)
	var/cooldown = 0
	var/cooldownMsg = TRUE
	var/cTriggered = FALSE

/datum/status_effect/chem/enthrall/on_apply()
	var/mob/living/carbon/M = owner
	var/datum/reagent/fermi/enthrall/E = locate(/datum/reagent/fermi/enthrall) in M.reagents.reagent_list
	if(!E.creatorID)
		message_admins("WARNING: FermiChem No master found in thrall, this makes me max sad.")
	enthrallID = E.creatorID
	enthrallGender = E.creatorGender
	master = get_mob_by_key(enthrallID)
	if(!E)
		message_admins("WARNING: No chem found in thrall!!!!")
	if(!master)
		message_admins("WARNING: No master! found in thrall!!!!")
	if(M.ckey == enthrallID)
		owner.remove_status_effect(src)//This shouldn't happen, but just in case
	redirect_component = WEAKREF(owner.AddComponent(/datum/component/redirect, list(COMSIG_LIVING_RESIST = CALLBACK(src, .proc/owner_resist)))) //Do resistance calc if resist is pressed#
	//redirect_component2 = WEAKREF(owner.AddComponent(/datum/component/redirect, list(COMSIG_LIVING_SAY = CALLBACK(src, .proc/owner_say)))) //Do resistance calc if resist is pressed
	//redirect_component3 = WEAKREF(owner.AddComponent(/datum/component/redirect, list(COMSIG_MOVABLE_HEAR = CALLBACK(src, .proc/owner_hear)))) //Do resistance calc if resist is pressed
	//RegisterSignal(owner, COMSIG_GLOB_LIVING_SAY_SPECIAL, .proc/owner_say)
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, .proc/owner_hear)
	//Might need to add redirect component for listening too.
	var/obj/item/organ/brain/B = M.getorganslot(ORGAN_SLOT_BRAIN) //It's their brain!
	mental_capacity = 500 - B.get_brain_damage()
	var/message = "[(owner.lewd?"I am a good pet for [enthrallGender].":"[master] is a really inspirational person!")]"
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "enthrall", /datum/mood_event/enthrall, message)
	to_chat(owner, "<span class='big warning'><i>You feel inexplicably drawn towards [master], their words having a demonstrable effect on you. It seems the closer you are to them, the stronger the effect is. However you aren't fully swayed yet and can still repeatedly resist their effects! (Mash resist to fight back!!)</i></span>")
	return ..()

/datum/status_effect/chem/enthrall/tick()
	//. = ..() //loop Please
	var/mob/living/carbon/M = owner

	//chem calculations
	if (owner.reagents.has_reagent("enthrall"))
		if (phase >= 2)
			enthrallTally += phase
	else
		if (phase < 3 && phase != 0)
			deltaResist += 3//If you've no chem, then you break out quickly
			if(prob(10))
				to_chat(owner, "<span class='notice'><i>Your mind starts to restore some of it's clarity as you feel the effects of the drug wain.</i></span>")
	if (mental_capacity <= 500 || phase == 4)
		if (owner.reagents.has_reagent("mannitol"))
			mental_capacity += 5
		if (owner.reagents.has_reagent("neurine"))
			mental_capacity += 10

	//mindshield check
	if(M.has_trait(TRAIT_MINDSHIELD))//If you manage to enrapture a head, wow, GJ.
		resistanceTally += 5
		if(prob(10))
			to_chat(owner, "<span class='notice'><i>You feel lucidity returning to your mind as the mindshield buzzes, attempting to return your brain to normal function.</i></span>")
		if(phase == 4)
			mental_capacity += 5

	//phase specific events
	switch(phase)
		if(-1)//fully removed
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "enthrall")
			owner.remove_status_effect(src)
		if(0)// sleeper agent
			return
		if(1)//Initial enthrallment
			if (enthrallTally > 100)
				phase += 1
				mental_capacity -= resistanceTally//leftover resistance per step is taken away from mental_capacity.
				resistanceTally /= 2
				enthrallTally = 0
				if(owner.lewd)
					to_chat(owner, "<span class='hypnophrase'><i>Your conciousness slips, as you sink deeper into trance and servitude.</i></span>")
				else

			else if (resistanceTally > 100)
				enthrallTally *= 0.5
				phase = -1
				resistanceTally = 0
				to_chat(owner, "<span class='warning'><i>You break free of the influence in your mind, your thoughts suddenly turning lucid!</i></span>")
				to_chat(owner, "<span class='big redtext'><i>You're now free of [master]'s influence, and fully independant oncemore.'</i></span>")
				owner.remove_status_effect(src) //If resisted in phase 1, effect is removed.
			if(prob(10))
				if(owner.lewd)
					to_chat(owner, "<span class='small hypnophrase'><i>[pick("It feels so good to listen to [master].", "You can't keep your eyes off [master].", "[master]'s voice is making you feel so sleepy.",  "You feel so comfortable with [master]", "[master] is so dominant, it feels right to obey them.")].</i></span>")
		if (2) //partially enthralled
			if (enthrallTally > 150)
				phase += 1
				mental_capacity -= resistanceTally//leftover resistance per step is taken away from mental_capacity.
				enthrallTally = 0
				resistanceTally /= 2
				if(owner.lewd)
					to_chat(owner, "<span class='notice'><i>Your mind gives, eagerly obeying and serving [master].</i></span>")
					to_chat(owner, "<span class='big nicegreen'><i>You are now fully enthralled to [master], and eager to follow their commands. However you find that in your intoxicated state you are unable to resort to violence. Equally you are unable to commit suicide, even if ordered to, as you cannot serve your [enthrallGender] in death. </i></span>")//If people start using this as an excuse to be violent I'll just make them all pacifists so it's not OP.
				else
					to_chat(owner, "<span class='big nicegreen'><i>You are unable to put up a resistance any longer, and now are under the control of [master]. However you find that in your intoxicated state you are unable to resort to violence. Equally you are unable to commit suicide, even if ordered to, as you cannot serve your [master] in death. </i></span>")
					owner.add_trait(TRAIT_PACIFISM, "MKUltra")
			else if (resistanceTally > 150)
				enthrallTally *= 0.5
				phase -= 1
				resistanceTally = 0
				to_chat(owner, "<span class='notice'><i>You manage to shake some of the effects from your addled mind, however you can still feel yourself drawn towards [master].</i></span>")
				//owner.remove_status_effect(src) //If resisted in phase 1, effect is removed. Not at the moment,
			if(prob(10))
				if(owner.lewd)
					to_chat(owner, "<span class='hypnophrase'><i>[pick("It feels so good to listen to [enthrallGender].", "You can't keep your eyes off [enthrallGender].", "[enthrallGender]'s voice is making you feel so sleepy.",  "You feel so comfortable with [enthrallGender]", "[enthrallGender] is so dominant, it feels right to obey them.")].</i></span>")
		if (3)//fully entranced
			if ((resistanceTally >= 200 && withdrawalTick >= 150) || (M.has_trait(TRAIT_MINDSHIELD) && resistanceTally >= 100))
				enthrallTally = 0
				phase -= 1
				resistanceTally = 0
				to_chat(owner, "<span class='notice'><i>The separation from [(owner.lewd?"your [enthrallGender]":"[master]")] sparks a small flame of resistance in yourself, as your mind slowly starts to return to normal.</i></span>")
				owner.remove_trait(TRAIT_PACIFISM, "MKUltra")
			if(prob(2))
				if(owner.lewd)
					to_chat(owner, "<span class='notice'><i>[pick("I belong to [enthrallGender].", "[enthrallGender] knows whats best for me.", "Obedence is pleasure.",  "I exist to serve [enthrallGender].", "[enthrallGender] is so dominant, it feels right to obey them.")].</i></span>")
		if (4) //mindbroken
			if (mental_capacity >= 499 && (owner.getBrainLoss() >=20 || M.has_trait(TRAIT_MINDSHIELD)) && !owner.reagents.has_reagent("MKUltra"))
				phase = 2
				mental_capacity = 500
				customTriggers = list()
				to_chat(owner, "<span class='notice'><i>Your mind starts to heal, fixing the damage caused by the massive ammounts of chem injected into your system earlier, .</i></span>")
				M.slurring = 0
				M.confused = 0
			else
				return//If you break the mind of someone, you can't use status effects on them.


	//distance calculations
	switch(get_dist(master, owner))
		if(0 to 8)//If the enchanter is within range, increase enthrallTally, remove withdrawal subproc and undo withdrawal effects.
			if(phase <= 2)
				enthrallTally += distancelist[get_dist(master, owner)+1]
			withdrawal = FALSE
			if(withdrawalTick > 0)
				withdrawalTick -= 2
			M.hallucination = max(0, M.hallucination - 2)
			M.stuttering = max(0, M.stuttering - 2)
			M.jitteriness = max(0, M.jitteriness - 2)
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing1")
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing2")
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing3")
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing3")
		if(9 to INFINITY)//If
			withdrawal = TRUE

	//Withdrawal subproc:
	if (withdrawal == TRUE)//Your minions are really REALLY needy.
		switch(withdrawalTick)//denial
			if(5)//To reduce spam
				to_chat(owner, "<span class='big warning'><i>You are unable to complete your [master]'s orders without their presence, and any commands given to you prior are not in effect until you are back with them.</i></span>")
			if(10 to 35)//Gives wiggle room, so you're not SUPER needy
				if(prob(5))
					to_chat(owner, "<span class='notice'><i>You're starting to miss [(owner.lewd?"your [enthrallGender]":"[master]")].</i></span>")
				if(prob(5))
					owner.adjustBrainLoss(0.5)
					to_chat(owner, "<i>[(owner.lewd?"[enthrallGender]":"[master]")] will surely be back soon</i>") //denial
			if(36)
				var/message = "[(owner.lewd?"I feel empty when [enthrallGender]'s not around..":"I miss [master]'s presence")]"
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing1", /datum/mood_event/enthrallmissing1, message)
			if(37 to 65)//barganing
				if(prob(10))
					to_chat(owner, "<i>They are coming back, right...?</i>")
					owner.adjustBrainLoss(1)
				if(prob(10))
					if(owner.lewd)
						to_chat(owner, "<i>I just need to be a good pet for [enthrallGender], they'll surely return if I'm a good pet.</i>")
					owner.adjustBrainLoss(-1)
			if(66)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing1")
				var/message = "[(owner.lewd?"I feel so lost in this complicated world without [enthrallGender]..":"I have to return to [master]!")]"
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing2", /datum/mood_event/enthrallmissing2, message)
				owner.stuttering += 200
				owner.jitteriness += 200
			if(67 to 90) //anger
				if(prob(10))
					addtimer(CALLBACK(M, /mob/verb/a_intent_change, INTENT_HARM), 2)
					addtimer(CALLBACK(M, /mob/proc/click_random_mob), 2)
					if(owner.lewd)
						to_chat(owner, "<span class='warning'>You are overwhelmed with anger at the lack of [enthrallGender]'s presence and suddenly lash out!</span>")
					else
						to_chat(owner, "<span class='warning'>You are overwhelmed with anger and suddenly lash out!</span>")
					owner.adjustBrainLoss(1)
			if(90)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing2")
				var/message = "[(owner.lewd?"Where are you [enthrallGender]??!":"I need to find [master]!")]"
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing3", /datum/mood_event/enthrallmissing3, message)
				if(owner.lewd)
					to_chat(owner, "<span class='warning'><i>You need to find your [enthrallGender] at all costs, you can't hold yourself back anymore!</i></span>")
				else
					to_chat(owner, "<span class='warning'><i>You need to find [master] at all costs, you can't hold yourself back anymore!</i></span>")
			if(91 to 120)//depression
				if(prob(20))
					owner.adjustBrainLoss(2.5)
					owner.stuttering += 20
					owner.jitteriness += 20
				if(prob(25))
					M.hallucination += 20
			if(121)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing3")
				var/message = "[(owner.lewd?"I'm all alone, It's so hard to continute without [enthrallGender]...":"I really need to find [master]!!!")]"
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing4", /datum/mood_event/enthrallmissing4, message)
				to_chat(owner, "<span class='warning'><i>You can hardly find the strength to continue without your [enthrallGender].</i></span>")
			if(120 to 140) //depression
				if(prob(15))
					owner.Stun(50)
					owner.emote("cry")//does this exist?
					if(owner.lewd)
						to_chat(owner, "<span class='warning'><i>You're unable to hold back your tears, suddenly sobbing as the desire to see your [enthrallGender] oncemore overwhelms you.</i></span>")
					else
						to_chat(owner, "<span class='warning'><i>You are overwheled with withdrawl from [master].</i></span>")
					owner.adjustBrainLoss(5)
					owner.stuttering += 20
					owner.jitteriness += 20
				if(prob(5))
					deltaResist += 5
			if(140 to INFINITY) //acceptance
				if(prob(15))
					deltaResist += 5
					if(prob(20))
						if(owner.lewd)
							to_chat(owner, "<i><span class='small green'>Maybe you'll be okay without your [enthrallGender].</i></span>")
						else
							to_chat(owner, "<i><span class='small green'>You feel your mental functions slowly begin to return.</i></span>")
				if(prob(10))
					owner.adjustBrainLoss(2)
					M.hallucination += 50

		withdrawalTick += 0.5

	//Status subproc - statuses given to you from your Master
	//currently 3 statuses; antiresist -if you press resist, increases your enthrallment instead, HEAL - which slowly heals the pet, CHARGE - which breifly increases speed, PACIFY - makes pet a pacifist.
	if (status)

		if(status == "Antiresist")
			if (statusStrength < 0)
				status = null
				to_chat(owner, "Your mind feels able to resist oncemore.")
			else
				statusStrength -= 1

		else if(status == "heal")
			if (statusStrength < 0)
				status = null
				to_chat(owner, "You finish licking your wounds.")
			else
				statusStrength -= 1
				owner.heal_overall_damage(1, 1, 0, FALSE, FALSE)
				cooldown += 1 //Cooldown doesn't process till status is done

		else if(status == "charge")
			owner.add_trait(TRAIT_GOTTAGOFAST, "MKUltra")
			status = "charged"
			if(master.lewd)
				to_chat(owner, "Your [enthrallGender]'s order fills you with a burst of speed!")
			else
				to_chat(owner, "[master]'s command fills you with a burst of speed!")

		else if (status == "charged")
			if (statusStrength < 0)
				status = null
				owner.remove_trait(TRAIT_GOTTAGOFAST, "MKUltra")
				owner.Knockdown(50)
				to_chat(owner, "Your body gives out as the adrenaline in your system runs out.")
			else
				statusStrength -= 1
				cooldown += 1 //Cooldown doesn't process till status is done

		else if (status == "pacify")
			owner.add_trait(TRAIT_PACIFISM, "MKUltraStatus")
			status = null

			//Truth serum?
			//adrenals?
			//M.next_move_modifier *= 0.5
			//M.adjustStaminaLoss(-5*REM)

	//final tidying
	resistanceTally  += deltaResist
	deltaResist = 0
	if (cooldown > 0)
		cooldown -= (1 + (mental_capacity/1000))
		cooldownMsg = FALSE
	else if (cooldownMsg == FALSE)
		if(master.lewd)
			to_chat(master, "<span class='notice'><i>Your pet [owner] appears to have finished internalising your last command.</i></span>")
		else
			to_chat(master, "<span class='notice'><i>Your thrall [owner] appears to have finished internalising your last command.</i></span>")
		cooldownMsg = TRUE
		cooldown = 0
	//..()

//Remove all stuff
/datum/status_effect/chem/enthrall/on_remove()
	var/mob/living/carbon/M = owner
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "enthrall")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "enthrallpraise")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "enthrallscold")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing1")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing2")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing3")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing4")
	qdel(redirect_component.resolve())
	redirect_component = null
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)
	owner.remove_trait(TRAIT_PACIFISM, "MKUltra")
	//UnregisterSignal(owner, COMSIG_GLOB_LIVING_SAY_SPECIAL)

/*
/datum/status_effect/chem/enthrall/mob/say(message, bubble_type, var/list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
		    if(master in message || master in message)
		        return
		    else
		        . = ..()
*/
//WORKS!! AAAAA

/datum/status_effect/chem/enthrall/proc/owner_hear(var/hearer, message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	if (cTriggered == TRUE)
		return
	var/mob/living/carbon/C = owner
	//message_admins("[C] heard something!")
	raw_message = lowertext(raw_message)
	for (var/trigger in customTriggers)
		var/cached_trigger = lowertext(trigger)
		//message_admins("[C] heard something: [message] vs [trigger] vs [raw_message]")
		if (findtext(raw_message, cached_trigger))//if trigger1 is the message
			message_admins("[C] has been triggered with [trigger]!")
			cTriggered = TRUE

			//Speak (Forces player to talk) works
			if (lowertext(customTriggers[trigger][1]) == "speak")//trigger2
				var/saytext = "Your mouth moves on it's own before you can even catch it."
				if(C.has_trait(TRAIT_NYMPHO))
					saytext += " You find yourself fully believing in the validity of what you just said and don't think to question it."
				to_chat(C, "<span class='notice'><i>[saytext]</i></span>")
				(C.say(customTriggers[trigger][2]))//trigger3


			//Echo (repeats message!) works
			else if (lowertext(customTriggers[trigger][1]) == "echo")//trigger2
				(to_chat(owner, "<span class='hypnophrase'><i>[customTriggers[trigger][2]]</i></span>"))//trigger3

			//Shocking truth! works
			else if (lowertext(customTriggers[trigger]) == "shock")
				if (C.canbearoused)
					C.electrocute_act(10, src, 1, FALSE, FALSE, FALSE, TRUE)//I've no idea how strong this is
					C.adjustArousalLoss(5)
					to_chat(owner, "<span class='warning'><i>Your muscles seize up, then start spasming wildy!</i></span>")
				else
					C.electrocute_act(15, src, 1, FALSE, FALSE, FALSE, TRUE)//To make up for the lack of effect

			//wah intensifies wah-rks
			else if (lowertext(customTriggers[trigger]) == "cum")//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				if (C.has_trait(TRAIT_NYMPHO))
					if (C.getArousalLoss() > 80)
						C.mob_climax(forced_climax=TRUE)
					else
						C.adjustArousalLoss(10)
				else
					C.throw_at(get_step_towards(speaker,C), 3, 1) //cut this if it's too hard to get working

			//kneel (knockdown)
			else if (lowertext(customTriggers[trigger]) == "kneel")//as close to kneeling as you can get, I suppose.
				to_chat(owner, "<span class='notice'><i>You drop to the ground unsurreptitiously.</i></span>")
				C.resting = 1
				C.lying = 1

			//strip (some) clothes
			else if (lowertext(customTriggers[trigger]) == "strip")//This wasn't meant to just be a lewd thing oops, is this pref breaking?
				var/mob/living/carbon/human/o = owner
				var/items = o.get_contents()
				for(var/obj/item/W in items)
					if(W == o.w_uniform || W == o.wear_suit)
						o.dropItemToGround(W, TRUE)
				to_chat(owner,"<span class='notice'><i>You feel compelled to strip your clothes.</i></span>")

			//trance
			else if (lowertext(customTriggers[trigger]) == "trance")//Maaaybe too strong.
				var/mob/living/carbon/human/o = owner
				o.apply_status_effect(/datum/status_effect/trance, 200, TRUE)

		//add more fun stuff!

			cTriggered = FALSE
	return
/*
/datum/status_effect/chem/enthrall/proc/owner_withdrawal(mob/living/carbon/M)
	//3 stages, each getting worse
*/
/datum/status_effect/chem/enthrall/proc/owner_resist()
	var/mob/living/carbon/M = owner
	to_chat(owner, "<span class='notice'><i>You attempt to fight against against [(owner.lewd?"[enthrallGender]":"[master]")]'s influence!'</i></span>")
	message_admins("Enthrall processing for [M]: enthrallTally: [enthrallTally], resistanceTally: [resistanceTally]")
	//message_admins("[M] is trying to resist!")
	if (status == "Sleeper" || phase == 0)
		return
	else if (phase == 4)
		if(owner.lewd)
			to_chat(owner, "<span class='warning'><i>Your mind is too far gone to even entertain the thought of resisting. Unless you can fix the brain damage, you won't be able to break free of your [enthrallGender]'s control.</i></span>")
		else
			to_chat(owner, "<span class='warning'><i>Your brain is too overwhelmed with from the high volume of chemicals in your system, rendering you unable to resist, unless you can fix the brain damage.</i></span>")
		return
	else if (phase == 3 && withdrawal == FALSE)
		if(owner.lewd)
			to_chat(owner, "<span class='hypnophrase'><i>The presence of your [enthrallGender] fully captures the horizon of your mind, removing any thoughts of resistance. Try getting away from them.</i></span>")
		else
			to_chat(owner, "<span class='hypnophrase'><i>You are unable to resist [master] in your current state. Try getting away from them.</i></span>")
		return
	else if (status == "Antiresist")//If ordered to not resist; resisting while ordered to not makes it last longer, and increases the rate in which you are enthralled.
		if (statusStrength > 0)
			if(owner.lewd)
				to_chat(owner, "<span class='warning'><i>The order from your [enthrallGender] to give in is conflicting with your attempt to resist, drawing you deeper into trance! You'll have to wait a bit before attemping again, lest your attempts become frustrated again.</i></span>")
			else
				to_chat(owner, "<span class='warning'><i>The order from your [master] to give in is conflicting with your attempt to resist. You'll have to wait a bit before attemping again, lest your attempts become frustrated again.</i></span>")
			statusStrength += 1
			enthrallTally += 1
			return
		else
			status = null
	if (deltaResist != 0)//So you can't spam it, you get one deltaResistance per tick.
		deltaResist += 0.1 //Though I commend your spamming efforts.
		return
	else
		deltaResist = 1

	if(prob(5))
		M.emote("me",1,"squints, shaking their head for a moment.")//shows that you're trying to resist sometimes
		deltaResist *= 1.5
	to_chat(owner, "You attempt to shake the mental cobwebs from your mind!")
	//base resistance
	if (M.canbearoused && M.has_trait(TRAIT_NYMPHO))//I'm okay with this being removed.
		deltaResist*= ((100 - M.arousalloss/100)/100)//more aroused you are, the weaker resistance you can give
	//else
	//	deltaResist *= 0.5
	//chemical resistance, brain and annaphros are the key to undoing, but the subject has to to be willing to resist.
	if (owner.reagents.has_reagent("mannitol"))
		deltaResist *= 1.25
	if (owner.reagents.has_reagent("neurine"))
		deltaResist *= 1.5
	if (!owner.has_trait(TRAIT_CROCRIN_IMMUNE) && M.canbearoused)
		if (owner.reagents.has_reagent("anaphro"))
			deltaResist *= 1.5
		if (owner.reagents.has_reagent("anaphro+"))
			deltaResist *= 2
		if (owner.reagents.has_reagent("aphro"))
			deltaResist *= 0.75
		if (owner.reagents.has_reagent("aphro+"))
			deltaResist *= 0.5

	//Antag resistance
	//cultists are already brainwashed by their god
	if(iscultist(owner))
		deltaResist *= 1.5
	else if (is_servant_of_ratvar(owner))
		deltaResist *= 1.5
	//antags should be able to resist, so they can do their other objectives. This chem does frustrate them, but they've all the tools to break free when an oportunity presents itself.
	else if (owner.mind.assigned_role in GLOB.antagonists)
		deltaResist *= 1.4

	//role resistance
	//Chaplains are already brainwashed by their god
	if(owner.mind.assigned_role == "Chaplain")
		deltaResist *= 1.5
	//Command staff has authority,
	if(owner.mind.assigned_role in GLOB.command_positions)
		deltaResist *= 1.4
		//if(owner.has_status == "sub"); power_multiplier *= 0.8 //for skylar //I'm kidding <3
	//Chemists should be familiar with drug effects
	if(owner.mind.assigned_role == "Chemist")
		deltaResist *= 1.3

	//Happiness resistance
	//Your Thralls are like pets, you need to keep them happy.
	if(owner.nutrition < 250)
		deltaResist += (250-owner.nutrition)/100
	if(owner.health < 100)//Harming your thrall will make them rebel harder.
		deltaResist *= ((120-owner.health)/100)+1
	//if()
	//Add cold/hot, oxygen, sanity, happiness? (happiness might be moot, since the mood effects are so strong)
	//Mental health could play a role too in the other direction

	//If you've a collar, you get a sense of pride
	if(istype(M.wear_neck, /obj/item/clothing/neck/petcollar))
		deltaResist *= 0.5
	if(M.has_trait(TRAIT_MINDSHIELD))
		deltaResist += 5//even faster!

	if (deltaResist>0)//just in case
		deltaResist /= phase//later phases require more resistance
	message_admins("[M] is trying to resist with a delta of [deltaResist]!")
	return

//I think this can be left out, but I'll leave the code incase anyone wants to add to it.
/*
/datum/status_effect/chem/enthrall/proc/owner_say(mob/speaker, message) //I can only hope this works

	//var/datum/status_effect/chem/enthrall/E = owner.has_status_effect(/datum/status_effect/chem/enthrall)
	//var/mob/living/master = E.master
	message_admins("[owner] said something")
	var/static/regex/owner_words = regex("[master]")
	if(findtext(message, owner_words))
		message = replacetext(lowertext(message), lowertext(master), "[enthrallGender]")
	return message
*/
