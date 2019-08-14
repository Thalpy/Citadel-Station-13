//Handheld culture
#define C_DEAD 0
#define C_BABY 1
#define C_YOUTH 2
#define C_ADOLESENT 3
#define C_YOUNG_ADULT 4
#define C_ADULT 5

/obj/culture
    var/health = 50
    var/happiness = 50
    var/intelligence = 0
    var/strength = 0
    var/agility = 0
    var/charisma = 0
    var/luck = 0
    var/nutrition = 20
    var/fatique = 0 //20 is max for now
    var/traits = list()//A list of stuff organs can pick up from exposing them to certain behavours
    var/name = "Humsquanch babnorp"
    var/age = C_BABY
    var/type = "Stem cells"
    //Combat vars
    var/cached_stats
    var/favouredStat
    var/attackPhrase = "bloody well punches the other organ! I say!"
    var/inGloriousCombat = FALSE //Prevent people from taking their organs when dueling

/obj/culture/Initialize()
	. = ..()
	create_reagents(50)//For heat and feeding

/obj/culture/process()
