// Citadel-specific Negative Traits

/datum/quirk/Hypno
	name = "Hypnotherapy user"
	desc = "You had hypnotherapy right before your shift, you're not sure it had any effects, though."
	mob_trait = "hypnotherapy"
	value = -1 //I mean, it can be a really bad trait to have, but on the other hand, some people want it?
	gain_text = "<span class='notice'>You really think the hypnotherapy helped you out.</span>"
	//lose_text = "<span class='notice'>You forget about the hypnotherapy you had, or did you even have it?</span>"

/datum/quirk/Hypno/add()
   //You caught me, it's not actually based off a trigger, stop spoiling the effect! Code diving ruins the magic!
   addtimer(CALLBACK(quirk_holder, /datum/quirk/Hypno/proc/triggered, quirk_holder), rand(12000, 36000))

/datum/quirk/Hypno/proc/triggered(quirk_holder)//I figured I might as well make a trait of code I added.
   var/mob/living/carbon/human/H = quirk_holder
   var/list/seen = viewers(8, get_turf(H))
   if(LAZYLEN(seen) == 0)
      to_chat(H, "<span class='notice'><i>That object accidentally sets off your implanted trigger, sending you into a hypnotic daze!</i></span>")
   else
      to_chat(H, "<span class='notice'><i>[pick(seen)] accidentally sets off your implanted trigger, sending you into a hypnotic daze!</i></span>")
   H.apply_status_effect(/datum/status_effect/trance, 200, TRUE)
   qdel(src)
