extends Node
class_name GUtils

static func addToStats(base : Dictionary, stats : Dictionary) -> Dictionary :
	for stat in stats.keys():
		if base.has(stat):
			base[stat] += stats[stat]
	
	base.merge(stats)
	
	return base
	
static func addToAttackStats(base : Dictionary, stats : Dictionary) -> Dictionary :
	if stats && stats.has("ATTACK"):
		addToStats(getOrCreateInDictionaryCategory(base, "ATTACK").get("ATTACK", {}), stats.get("ATTACK", {}))
	return base

static func getOrCreateInDictionaryCategory(dic : Dictionary, key : Variant):
	if dic.has(key):
		return dic[key]
	
	dic[key] = {}
	return dic

static func getNmericProperty(dic : Dictionary, group : String, property : String, default : int = 0):
	return dic.get(group,{}).get(property,default)

static func getFloatingProperty(dic : Dictionary, group : String, property : String, default : float = 0):
	return dic.get(group,{}).get(property,default)

static func getStringProperty(dic : Dictionary, group : String, property : String, default : String = ""):
	return dic.get(group,{}).get(property,default)
