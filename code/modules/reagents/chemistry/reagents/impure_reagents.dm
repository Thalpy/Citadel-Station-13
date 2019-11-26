//Reagents produced by metabolising/reacting fermichems inoptimally, i.e. inverse_chems or impure_chems
//Inverse = Splitting
//Invert = Whole conversion
//Generally, make their pHes more acidic if acidic, or more basic if basic, so that you push them towards heartburn

//Causes metabolic stress, and that's it.
/datum/reagent/impure
	name = "Chemical Isomers"
	id = "generic_impure"
	description = "Toxic chemical isomers made from impure reactions. At low volumes will cause light toxin damage, but as the volume increases, it deals larger amounts, damages the liver, then eventually the heart. This is default impure chem for all chems, and changes only if stated."
	chemical_flags = REAGENT_INVISIBLE | REAGENT_SNEAKYNAME //by default, it will stay hidden on splitting, but take the name of the source on inverting
	var/metastress = 1
	var/obj/item/organ/liver/L
	pH = 3

/datum/reagent/impure/on_mob_add(mob/living/L)
	var/mob/living/carbon/C = L
	if(C && (!(L)))
		L = C.getorganslot(ORGAN_SLOT_LIVER) //reduce calls
	..()

/datum/reagent/impure/on_mob_life(mob/living/carbon/C)
	if(!L)//Though, lets be safe
		L = C.getorganslot(ORGAN_SLOT_LIVER)
	L.adjustMetabolicStress(metastress)
	..()

/datum/reagent/impure/fermiTox
	id = "fermiTox"
	data = "merge"
	color = "FFFFFF"
	can_synth = FALSE
	var/potency = 1 //potency multiplies the volume when added.
	pH = 2

//I'm concerned this is too weak, but I also don't want deathmixes.
//TODO: liver damage, 100+ heart
/datum/reagent/impure/fermiTox/on_mob_life(mob/living/carbon/C, method)
	C.adjustToxLoss(2, TRUE)
	..()

/datum/reagent/impure/mannitol
	name = "Mannitoll"
	id = "mannitol_impure"
	description = "Inefficiently causes brain damage."
	color = "#DCDCFF"
	pH = 12.4

/datum/reagent/impure/mannitol/on_mob_life(mob/living/carbon/C)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, cached_purity*REM)
	..()

//I am incapable of making anything simple
/datum/reagent/impure/neurine
	name = "Neruwhine"
	id = "neurine_impure"
	description = "Causes the patient a temporary trauma."
	color = "#DCDCFF"
	pH = 13.4
	metabolization_rate = 0.4 * REM
	metastress = 0.5
	var/datum/brain_trauma/temp_trauma

/datum/reagent/impure/neurine/on_mob_life(mob/living/carbon/C)
	.=..()
	if(temp_trauma)
		return
	if(!(prob(cached_purity)))
		return
	var/traumalist = subtypesof(/datum/brain_trauma)
	traumalist -= /datum/brain_trauma/severe/split_personality //Uses a ghost, I don't want to use a ghost for a temp thing.
	var/datum/brain_trauma/BT = pick(traumalist)
	var/obj/item/organ/brain/B = C.getorganslot(ORGAN_SLOT_BRAIN)
	if(!(B.can_gain_trauma(BT) ) )
		return
	B.brain_gain_trauma(BT, TRAUMA_RESILIENCE_MAGIC)
	temp_trauma = BT

/datum/reagent/impure/neurine/on_mob_delete(mob/living/carbon/C)
	.=..()
	if(!temp_trauma)
		return
	if(istype(temp_trauma, /datum/brain_trauma/special/imaginary_friend))//Good friends stay by you, no matter what
		return
	C.cure_trauma_type(temp_trauma, resilience = TRAUMA_RESILIENCE_MAGIC)

/datum/reagent/impure/corazone
	name = "Corazargh" //It's what you yell! Though, if you've a better name feel free.
	id = "corazone_inverse"
	description = "Can induces a Myocardial Infarction while in the patient if their heart is damaged."
	color = "#F5F5F5"
	self_consuming = TRUE
	pH = 13.5
	metabolization_rate = 0.075 * REM
	metastress = 0.2
	var/datum/disease/heart_failure/temp_myo

/datum/reagent/impure/corazone/on_mob_add(mob/living/L)
	var/mob/living/carbon/C = L
	if(!C)
		return
	var/obj/item/organ/heart/H = C.getorganslot(ORGAN_SLOT_HEART)
	if(!(prob(H.damage)))
		return
	var/datum/disease/D = new /datum/disease/heart_failure
	if(L.ForceContractDisease(D))
		temp_myo = D
	..()

/datum/reagent/impure/corazone/on_mob_delete(mob/living/L)
	if(temp_myo)
		temp_myo.cure()
	..()

/datum/reagent/impure/antihol
	name = "Soothehol"
	id = "antihol_impure"
	description = "Soothes a patient's liver"
	taste_description = "coooked egg"
	color = "#00B4C8"
	pH = 2.5
	metastress = -0.1

/datum/reagent/impure/antihol/on_mob_life(mob/living/carbon/C)
	if(!L)//Since this is run before the parent proc.
		L = C.getorganslot(ORGAN_SLOT_LIVER)
	var/treat_amount = 0.2 + (cached_purity/5) //0.2-0.4
	L.adjustMetabolicStress(-treat_amount, -cached_purity*15) //Handles liver healing, needs over 0.66 for chronic
	..()

/datum/reagent/impure/antihol/inverse
	name = "Prohol"
	id = "antihol_inverse"
	description = "Promotes alcoholic substances within the patients body, making their effects more potent."
	taste_description = "alcohol" //mostly for sneaky slips
	chemical_flags = REAGENT_INVISIBLE
	metastress = 0.35

/datum/reagent/impure/antihol/inverse/on_mob_life(mob/living/carbon/C)
	for(var/datum/reagent/consumable/ethanol/alch in C.reagents.reagent_list)
		alch.boozepwr += 2
	..()

/datum/reagent/impure/oculine
	name = "Oculater"
	id = "oculine_impure"
	description = "temporarily blinds the patient."
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolization_rate = 2
	metastress = 1.2
	taste_description = "funky toxin"
	pH = 13

/datum/reagent/impure/oculine/on_mob_life(mob/living/carbon/C)
	if(prob(100*(1-cached_purity)))
		C.become_blind("oculine_impure")
	..()

/datum/reagent/impure/oculine/on_mob_delete(mob/living/L)
	L.cure_blind("oculine_impure")
	..()

/datum/reagent/impure/inacusiate
	name = "Tinyacusiate"
	id = "inacusiate_impure"
	description = "Makes the patient hard of hearing, and slowly causes ear damage."
	reagent_state = LIQUID
	color = "#FFFFFF"
	metastress = 0.75
	taste_description = "the heat evaporating from your mouth."
	pH = 1

/datum/reagent/impure/inacusiate/on_mob_add(mob/living/L)
	RegisterSignal(L, COMSIG_MOVABLE_HEAR, .proc/owner_hear)
	..()

/datum/reagent/impure/oculine/on_mob_life(mob/living/carbon/C)
	C.adjustOrganLoss(ORGAN_SLOT_EARS, (1-cached_purity))
	..()

/datum/reagent/impure/inacusiate/on_mob_delete(mob/living/L)
	UnregisterSignal(L, COMSIG_MOVABLE_HEAR)
	..()

/datum/reagent/impure/inacusiate/proc/owner_hear(var/hearer, message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	spans += "small"
	message_admins("<span class='small'>[message]</span>")
