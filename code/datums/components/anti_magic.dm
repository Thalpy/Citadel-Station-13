/datum/component/anti_magic
	var/magic = list()
	var/holy = list()

/datum/component/anti_magic/Initialize(_magic = FALSE, _holy = FALSE)
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/on_equip)
		RegisterSignal(parent, COMSIG_ITEM_DROPPED, .proc/on_drop)
	else if(ismob(parent)) //Can this ever be removed? At the moment I don't see if it can, but if it can, you need to remove it from the magic/holy lists
		RegisterSignal(parent, COMSIG_MOB_RECEIVE_MAGIC, .proc/can_protect)
	else
		return COMPONENT_INCOMPATIBLE

	if(_magic)
		magic["[parent]"] += _magic
	if(_holy)
		holy["[parent]"] += _holy

/datum/component/anti_magic/proc/on_equip(datum/source, mob/equipper, slot)
	RegisterSignal(equipper, COMSIG_MOB_RECEIVE_MAGIC, .proc/can_protect, TRUE)

/datum/component/anti_magic/proc/on_drop(datum/source, mob/user)
	UnregisterSignal(user, COMSIG_MOB_RECEIVE_MAGIC)
	if(magic["source"])
		magic -= list("[parent]" = _magic)
	if(holy["source"])
		holy -= list("[parent]" = _holy)

//Returns the percentage resist, if the spell is holy AND magic, and the item is holy AND magic, then it will use both of the object's resist boons.
/datum/component/anti_magic/proc/can_protect(datum/source, _magic, _holy, list/protection_sources)
	if(_magic && LAZYLEN(magic))
		protection_sources += magic


	if(_holy && LAZYLEN(holy))
		var/temp_holy = holy

		for(var/i in holy) //Merge duplicate entries into one single entry
		    if(protection_sources[i])
		        protection_sources[i] += holy[i]
				temp_holy -= "[i]"
		protection_sources += temp_holy

	if(!len(protection_sources))//If no sources then nothing
		return

	return COMPONENT_BLOCK_MAGIC
