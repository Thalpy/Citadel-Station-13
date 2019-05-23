// Citadel-specific Positive Traits

/datum/quirk/BloodPressure
	name = "Synthetic blood"
	desc = "You've got a new form of synthetic blood that increases the total blood volume inside of you!"
	value = 1
	mob_trait = TRAIT_HIGH_BLOOD
	gain_text = "<span class='notice'>You feel full of blood!</span>"
	lose_text = "<span class='notice'>You feel like your blood pressure went down.</span>"

/datum/quirk/BloodPressure/add()
	var/mob/living/M = quirk_holder
	M.blood_ratio = 1.2
