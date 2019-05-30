//TO TWEAK:

/datum/chemical_reaction/fermi
	mix_sound = 'sound/effects/bubbles.ogg'

//Called for every reaction step
/datum/chemical_reaction/fermi/proc/FermiCreate(holder) //You can get holder by reagents.holder WHY DID I LEARN THIS NOW???
	return

//Called when reaction STOP_PROCESSING
/datum/chemical_reaction/fermi/proc/FermiFinish(datum/reagents/holder, multipler) //You can get holder by reagents.holder WHY DID I LEARN THIS NOW???
	return

//Called when temperature is above a certain threshold, or if purity is too low.
/datum/chemical_reaction/fermi/proc/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH, Exploding = FALSE) //You can get holder by reagents.holder WHY DID I LEARN THIS NOW???
	if (Exploding == TRUE)
		return

	if(!pH)//Dunno how things got here without a pH.
		pH = 7
	var/ImpureTot = 0
	//var/pHmod = 1
	var/turf/T = get_turf(my_atom)
	if(temp>500)//if hot, start a fire
		switch(temp)
			if (500 to 750)
				for(var/turf/turf in range(1,T))
					new /obj/effect/hotspot(turf)

			if (751 to 1100)
				for(var/turf/turf in range(2,T))
					new /obj/effect/hotspot(turf)

			if (1101 to INFINITY) //If you're crafty
				for(var/turf/turf in range(3,T))
					new /obj/effect/hotspot(turf)


	message_admins("Fermi explosion at [T], with a temperature of [temp], pH of [pH], Impurity tot of [ImpureTot].")
	var/datum/reagents/R = new/datum/reagents(3000)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()

	for (var/datum/reagent/reagent in my_atom.reagents.reagent_list) //make gas for reagents
		if (istype(reagent, /datum/reagent/fermi))
			R.add_reagent(reagent.id, reagent.volume)
		else if (istype(reagent, /datum/reagent/toxin/plasma))
			R.add_reagent(reagent.id, reagent.volume) //for !FUN! (am I doing this right?)
		continue //Only allow fermichems into the mix (specific fermi explosions are handled elsewhere)
		if (reagent.purity < 0.6)
			ImpureTot = (ImpureTot + (1-reagent.purity)) / 2

	if(pH < 4) //if acidic, make acid spray
		R.add_reagent("fermiAcid", ((volume/3)/pH))

	if(R.reagent_list)
		s.set_up(R, (volume/10), 10, T)
		s.start()

	if (pH > 10) //if alkaline, small explosion.
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round((volume/30)*(pH-9)), T, 0, 0)
		e.start()

	if(!ImpureTot == 0) //If impure, v.small emp
		ImpureTot *= volume
		empulse(T, volume/10, ImpureTot/10, 1)

	my_atom.reagents.clear_reagents() //just in case
	return

/datum/chemical_reaction/fermi/eigenstate//done
	name = "Eigenstasium"
	id = "eigenstate"
	results = list("eigenstate" = 0.1)
	required_reagents = list("bluespace" = 0.1, "stable_plasma" = 0.1, "sugar" = 0.1)
	mix_message = "the reaction zaps suddenly!"
	//FermiChem vars:
	OptimalTempMin = 350 // Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax = 600 // Upper end for above
	ExplodeTemp = 750 //Temperature at which reaction explodes
	OptimalpHMin = 6 // Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax = 8 // Higest value for above
	ReactpHLim = 4 // How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact = 0 // How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT = 0.6 // How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH = 2 // How sharp the pH exponential curve is (to the power of value)
	ThermicConstant = 5 //Temperature change per 1u produced
	HIonRelease = -0.1 //pH change per 1u reaction
	RateUpLim = 5 //Optimal/max rate possible if all conditions are perfect
	FermiChem = TRUE//If the chemical uses the Fermichem reaction mechanics
	FermiExplode = FALSE //If the chemical explodes in a special way

/datum/chemical_reaction/fermi/eigenstate/FermiFinish(datum/reagents/holder, var/atom/my_atom)//Strange how this doesn't work but the other does.
	var/turf/open/location = get_turf(my_atom)
	var/datum/reagent/fermi/eigenstate/E = locate(/datum/reagent/fermi/eigenstate) in my_atom.reagents.reagent_list
	E.location_created = location


//serum
/datum/chemical_reaction/fermi/SDGF //DONE
	name = "Synthetic-derived growth factor"
	id = "SDGF"
	results = list("SDGF" = 0.3)
	required_reagents = list("stable_plasma" = 0.5, "slimejelly" = 0.5, "uranium" = 0.5, "synthflesh" = 0.5, "blood" = 0.5)
	mix_message = "the reaction gives off a blorble!"
	//FermiChem vars:
	OptimalTempMin 		= 600 		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 630 		// Upper end for above
	ExplodeTemp 		= 635 		// Temperature at which reaction explodes
	OptimalpHMin 		= 3 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 3.5 		// Higest value for above
	ReactpHLim 			= 2 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 4 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 4 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= -5 		// Temperature change per 1u produced
	HIonRelease 		= 0.05 		// pH change per 1u reaction (inverse for some reason)
	RateUpLim 			= 3 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	FermiExplode 		= TRUE		// If the chemical explodes in a special way
	PurityMin 			= 0.2

/datum/chemical_reaction/fermi/SDGF/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)//Spawns an angery teratoma!! Spooky..! be careful!! TODO: Add teratoma slime subspecies
	var/turf/T = get_turf(my_atom)
	var/mob/living/simple_animal/slime/S = new(T,"grey")
	S.damage_coeff = list(BRUTE = 0.9 , BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	S.name = "Living teratoma"
	S.real_name = "Living teratoma"
	S.rabid = 1//Make them an angery boi, grr grr
	S.color = "#810010"
	my_atom.reagents.clear_reagents()
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The cells clump up into a horrifying tumour!</span>")

/datum/chemical_reaction/fermi/BElarger
	name = "Sucubus milk"
	id = "BElarger"
	results = list("BElarger" = 0.6)
	required_reagents = list("salglu_solution" = 0.1, "milk" = 0.5, "synthflesh" = 0.2, "silicon" = 0.2, "aphro" = 0.2)
	mix_message = "the reaction gives off a mist of milk."
	//FermiChem vars:
	OptimalTempMin 			= 200
	OptimalTempMax			= 800
	ExplodeTemp 			= 900
	OptimalpHMin 			= 8
	OptimalpHMax 			= 12
	ReactpHLim 				= 3
	CatalystFact 			= 0
	CurveSharpT 			= 2
	CurveSharppH 			= 2
	ThermicConstant 		= 1
	HIonRelease 			= 0.5
	RateUpLim 				= 5
	FermiChem				= TRUE
	FermiExplode 			= TRUE
	PurityMin 				= 0.1

/datum/chemical_reaction/fermi/BElarger/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)
	var/obj/item/organ/genital/breasts/B = new /obj/item/organ/genital/breasts(get_turf(my_atom))
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The reaction suddenly condenses, creating a pair of breasts!</b></span>")//OwO
	var/datum/reagent/fermi/BElarger/BE = locate(/datum/reagent/fermi/BElarger) in my_atom.reagents.reagent_list
	B.size = ((BE.volume * BE.purity) / 10) //half as effective.
	my_atom.reagents.clear_reagents()

/datum/chemical_reaction/fermi/PElarger
	name = "Incubus draft"
	id = "PElarger"
	results = list("PElarger" = 0.3)
	required_reagents = list("blood" = 0.5, "synthflesh" = 0.2, "carbon" = 0.2, "aphro" = 0.2, "salglu_solution" = 0.1,)
	mix_message = "the reaction gives off a spicy mist."
	//FermiChem vars:
	OptimalTempMin 			= 200
	OptimalTempMax			= 800
	ExplodeTemp 			= 900
	OptimalpHMin 			= 2
	OptimalpHMax 			= 6
	ReactpHLim 				= 3
	CatalystFact 			= 0
	CurveSharpT 			= 2
	CurveSharppH 			= 2
	ThermicConstant 		= 1
	HIonRelease 			= -0.5
	RateUpLim 				= 5
	FermiChem				= TRUE
	FermiExplode 			= TRUE
	PurityMin 				= 0.1

/datum/chemical_reaction/fermi/PElarger/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)
	var/obj/item/organ/genital/penis/P = new /obj/item/organ/genital/penis(get_turf(my_atom))
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The reaction suddenly condenses, creating a penis!</b></span>")//OwO
	var/datum/reagent/fermi/PElarger/PE = locate(/datum/reagent/fermi/PElarger) in my_atom.reagents.reagent_list
	P.length = ((PE.volume * PE.purity) / 10)//half as effective.
	my_atom.reagents.clear_reagents()

/datum/chemical_reaction/fermi/astral
	name = "Astrogen"
	id = "astral"
	results = list("astral" = 0.5)
	required_reagents = list("eigenstate" = 0.1, "plasma" = 0.3, "synaptizine" = 0.1, "aluminium" = 0.5)
	//FermiChem vars:
	OptimalTempMin 			= 700
	OptimalTempMax			= 800
	ExplodeTemp 			= 1150
	OptimalpHMin 			= 10
	OptimalpHMax 			= 13
	ReactpHLim 				= 2
	CatalystFact 			= 0
	CurveSharpT 			= 1
	CurveSharppH 			= 1
	ThermicConstant 		= 25
	HIonRelease 			= 1
	RateUpLim 				= 15
	FermiChem				= TRUE
	FermiExplode 			= TRUE
	PurityMin 				= 0.25


/datum/chemical_reaction/fermi/enthrall/
	name = "MKUltra"
	id = "enthrall"
	results = list("enthrall" = 0.5)
	//required_reagents = list("iron" = 1, "iodine" = 1) Test vars
	required_reagents = list("cocoa" = 0.1, "astral" = 0.1, "mindbreaker" = 0.1, "psicodine" = 0.1, "happiness" = 0.1)
	required_catalysts = list("blood" = 1)
	mix_message = "the reaction gives off a burgundy plume of smoke!"
	//FermiChem vars:
	OptimalTempMin 			= 780
	OptimalTempMax			= 800
	ExplodeTemp 			= 830
	OptimalpHMin 			= 12
	OptimalpHMax 			= 13
	ReactpHLim 				= 2
	//CatalystFact 			= 0
	CurveSharpT 			= 0.5
	CurveSharppH 			= 4
	ThermicConstant 		= 15
	HIonRelease 			= 0.1
	RateUpLim 				= 1
	FermiChem				= TRUE
	FermiExplode 			= TRUE
	PurityMin 				= 0.2



/datum/chemical_reaction/fermi/enthrall/FermiFinish(datum/reagents/holder, var/atom/my_atom)
	message_admins("On finish for enthral proc'd")
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in my_atom.reagents.reagent_list
	var/datum/reagent/fermi/enthrall/E = locate(/datum/reagent/fermi/enthrall) in my_atom.reagents.reagent_list
	if(!B.data)
		var/list/seen = viewers(5, get_turf(my_atom))
		for(var/mob/M in seen)
			to_chat(M, "<span class='warning'>The reaction splutters and fails to react.</span>") //if this appears, WHAT?!
			E.purity = 0
	if (B.data.["gender"] == "female")
		E.data.["creatorGender"] = "Mistress"
		E.creatorGender = "Mistress"
	else
		E.data.["creatorGender"] = "Master"
		E.creatorGender = "Master"
	E.data["creatorName"] = B.data.["real_name"]
	E.creatorName = B.data.["real_name"]
	E.data.["creatorID"] = B.data.["ckey"]
	E.creatorID = B.data.["ckey"]

/datum/chemical_reaction/fermi/enthrall/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)
	var/turf/T = get_turf(my_atom)
	var/datum/reagents/R = new/datum/reagents(1000)
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.add_reagent("enthrallExplo", volume/2)
	s.set_up(R, volume, T)
	s.start()
	my_atom.reagents.clear_reagents()

/datum/chemical_reaction/fermi/hatmium // done
	name = "Hat growth serum"
	id = "hatmium"
	results = list("hatmium" = 0.5)
	required_reagents = list("whiskey" = 0.1, "nutriment" = 0.3, "cooking_oil" = 0.2, "iron" = 0.1)
	//mix_message = ""
	//FermiChem vars:
	OptimalTempMin 	= 500
	OptimalTempMax 	= 700
	ExplodeTemp 	= 750
	OptimalpHMin 	= 2
	OptimalpHMax 	= 5
	ReactpHLim 		= 3
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 8
	CurveSharppH 	= 0.5
	ThermicConstant = -2
	HIonRelease 	= -0.5
	RateUpLim 		= 2
	FermiChem 		= TRUE
	FermiExplode 	= TRUE
	PurityMin		= 0.5

/datum/chemical_reaction/fermi/hatmium/FermiExplode(src, var/atom/my_atom, volume, temp, pH)
	var/obj/item/clothing/head/hattip/hat = new /obj/item/clothing/head/hattip(get_turf(my_atom))
	hat.animate_atom_living()
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The makes an off sounding pop, as a hat suddenly climbs out of the beaker!</b></span>")
	my_atom.reagents.clear_reagents()

/datum/chemical_reaction/fermi/furranium
	name = "Furranium"
	id = "furranium"
	results = list("furranium" = 0.5)
	required_reagents = list("aphro" = 0.1, "moonsugar" = 0.1, "silver" = 0.2, "salglu_solution" = 0.1)
	mix_message = "You think you can hear a howl come from the beaker."
	//FermiChem vars:
	OptimalTempMin 	= 350
	OptimalTempMax 	= 600
	ExplodeTemp 	= 700
	OptimalpHMin 	= 8
	OptimalpHMax 	= 10
	ReactpHLim 		= 1
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 2
	CurveSharppH 	= 0.5
	ThermicConstant = -10
	HIonRelease 	= -0.2
	RateUpLim 		= 2
	FermiChem 		= TRUE
	PurityMin		= 0.30

//FOR INSTANT REACTIONS - DO NOT MULTIPLY LIMIT BY 10.
//There's a weird rounding error or something ugh.

//Nano-b-gone
/datum/chemical_reaction/fermi/naninte_b_gone//done test
	name = "Naninte bain"
	id = "naninte_b_gone"
	results = list("naninte_b_gone" = 4)
	required_reagents = list("synthflesh" = 1, "uranium" = 1, "iron" = 1, "salglu_solution" = 1)
	mix_message = "the reaction gurgles, encapsulating the reagents in flesh before the emp can be set off."
	required_temp = 499//To force fermireactions before EMP.
	//FermiChem vars:
	OptimalTempMin 	= 500
	OptimalTempMax 	= 600
	ExplodeTemp 	= 700
	OptimalpHMin 	= 6
	OptimalpHMax 	= 6.25
	ReactpHLim 		= 3
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 0
	CurveSharppH 	= 1
	ThermicConstant = 5
	HIonRelease 	= 0.01
	RateUpLim 		= 1
	FermiChem 		= TRUE
	PurityMin		= 0.15

/datum/chemical_reaction/fermi/fermiABuffer//done test
	name = "Acetic acid buffer"
	id = "fermiABuffer"
	results = list("fermiABuffer" = 20) //acetic acid
	required_reagents = list("salglu_solution" = 2, "ethanol" = 6, "oxygen" = 6, "water" = 6)
	//FermiChem vars:
	OptimalTempMin 	= 250
	OptimalTempMax 	= 500
	ExplodeTemp 	= 9999 //check to see overflow doesn't happen!
	OptimalpHMin 	= 2
	OptimalpHMax 	= 6
	ReactpHLim 		= 0
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 1
	CurveSharppH 	= 0
	ThermicConstant = 0
	HIonRelease 	= -0.01
	RateUpLim 		= 20
	FermiChem 		= TRUE


/datum/chemical_reaction/fermi/fermiABuffer/FermiFinish(datum/reagents/holder, var/atom/my_atom) //might need this
	var/datum/reagent/fermi/fermiABuffer/Fa = locate(/datum/reagent/fermi/fermiABuffer) in my_atom.reagents.reagent_list
	Fa.data = 3

/datum/chemical_reaction/fermi/fermiBBuffer//done test
	name = "Ethyl Ethanoate buffer"
	id = "fermiBBuffer"
	results = list("fermiBBuffer" = 15)
	required_reagents = list("fermiABuffer" = 5, "ethanol" = 5, "salglu_solution" = 1, "water" = 5)
	required_catalysts = list("sacid" = 1) //vagely acetic
	//FermiChem vars:
	OptimalTempMin 	= 250
	OptimalTempMax 	= 500
	ExplodeTemp 	= 9999 //check to see overflow doesn't happen!
	OptimalpHMin 	= 8
	OptimalpHMax 	= 12
	ReactpHLim 		= 0
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 1
	CurveSharppH 	= 0
	ThermicConstant = 0
	HIonRelease 	= 0.01
	RateUpLim 		= 15
	FermiChem 		= TRUE


/datum/chemical_reaction/fermi/fermiBBuffer/FermiFinish(datum/reagents/holder, var/atom/my_atom) //might need this
	var/datum/reagent/fermi/fermiBBuffer/Fb = locate(/datum/reagent/fermi/fermiBBuffer) in my_atom.reagents.reagent_list
	Fb.data = 11

//This has to be set up so multiple reactions can occur at once.

/datum/chemical_reaction/fermi/equlibrium1
	name = "Equlibrium test 1"
	id = "equlibrium1"
	results = list("equlibrium1" = 1.5)
	required_reagents = list("water" = 0.5, "ethanol" = 0.5, "water" = 0.5)
	//FermiChem vars:
	OptimalTempMin 	= 400
	OptimalTempMax 	= 600
	ExplodeTemp 	= 800 //check to see overflow doesn't happen!
	OptimalpHMin 	= 6
	OptimalpHMax 	= 8
	ReactpHLim 		= 2
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 1
	CurveSharppH 	= 1
	ThermicConstant = 0
	HIonRelease 	= -0.05
	RateUpLim 		= 3
	FermiChem 		= TRUE

/datum/chemical_reaction/fermi/equlibrium2
	name = "Equlibrium test 2"
	id = "equlibrium2"
	results = list("equlibrium1" = 0.1)
	required_reagents = list("equlibrium2" = 0.1)
	//FermiChem vars:
	OptimalTempMin 	= 400
	OptimalTempMax 	= 600
	ExplodeTemp 	= 800 //check to see overflow doesn't happen!
	OptimalpHMin 	= 6
	OptimalpHMax 	= 8
	ReactpHLim 		= 2
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 1
	CurveSharppH 	= 1
	ThermicConstant = 0
	HIonRelease 	= -0.05
	RateUpLim 		= 1.5
	FermiChem 		= TRUE

/datum/chemical_reaction/fermi/equlibrium22
	name = "Equlibrium test 22"
	id = "equlibrium22"
	results = list("equlibrium2" = 0.1)
	required_reagents = list("equlibrium1" = 0.1)
	//FermiChem vars:
	OptimalTempMin 	= 400
	OptimalTempMax 	= 600
	ExplodeTemp 	= 800 //check to see overflow doesn't happen!
	OptimalpHMin 	= 6
	OptimalpHMax 	= 8
	ReactpHLim 		= 2
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 1
	CurveSharppH 	= 1
	ThermicConstant = 0
	HIonRelease 	= -0.05
	RateUpLim 		= 1.5
	FermiChem 		= TRUE

/datum/chemical_reaction/fermi/equlibrium3
	name = "Equlibrium test 3"
	id = "equlibrium3"
	results = list("equlibrium3" = 0.1)
	required_reagents = list("equlibrium2" = 0.1)
	//FermiChem vars:
	OptimalTempMin 	= 460
	OptimalTempMax 	= 600
	ExplodeTemp 	= 800 //check to see overflow doesn't happen!
	OptimalpHMin 	= 6
	OptimalpHMax 	= 8
	ReactpHLim 		= 2
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 0.5
	CurveSharppH 	= 1
	ThermicConstant = 0
	HIonRelease 	= -0.05
	RateUpLim 		= 1.5
	FermiChem 		= TRUE

/datum/chemical_reaction/fermi/Fequlibrium1
	name = "FEqulibrium test 1"
	id = "Fequlibrium1"
	results = list("Fequlibrium1" = 0.1)
	required_reagents = list("equlibrium3" = 0.1)
	//FermiChem vars:
	OptimalTempMin 	= 460
	OptimalTempMax 	= 600
	ExplodeTemp 	= 800 //check to see overflow doesn't happen!
	OptimalpHMin 	= 4
	OptimalpHMax 	= 6
	ReactpHLim 		= 0
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 1
	CurveSharppH 	= 0
	ThermicConstant = 0
	HIonRelease 	= -0.05
	RateUpLim 		= 0.5
	FermiChem 		= TRUE

/datum/chemical_reaction/fermi/Fequlibrium2
	name = "FEqulibrium test 2"
	id = "Fequlibrium2"
	results = list("Fequlibrium2" = 0.1)
	required_reagents = list("equlibrium4" = 0.1)
	//FermiChem vars:
	OptimalTempMin 	= 400
	OptimalTempMax 	= 600
	ExplodeTemp 	= 800 //check to see overflow doesn't happen!
	OptimalpHMin 	= 4
	OptimalpHMax 	= 8
	ReactpHLim 		= 2
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 2
	CurveSharppH 	= 0
	ThermicConstant = 0
	HIonRelease 	= -0.05
	RateUpLim 		= 0.5
	FermiChem 		= TRUE

/datum/chemical_reaction/fermi/equlibrium4
	name = "Equlibrium test 4"
	id = "equlibrium4"
	results = list("equlibrium4" = 0.1)
	required_reagents = list("equlibrium3" = 0.1)
	//FermiChem vars:
	OptimalTempMin 	= 460
	OptimalTempMax 	= 600
	ExplodeTemp 	= 800 //check to see overflow doesn't happen!
	OptimalpHMin 	= 6
	OptimalpHMax 	= 8
	ReactpHLim 		= 0
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 1
	CurveSharppH 	= 0
	ThermicConstant = 0
	HIonRelease 	= -0.05
	RateUpLim 		= 0.5
	FermiChem 		= TRUE
