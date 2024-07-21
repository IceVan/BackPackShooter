extends Node
class_name GUtils

static var INVENTORY_CELL_BASE_SIZE = 64

static func multiplyDmgStats(stats : Dictionary, factor : float) -> Dictionary :
	if stats.has("DMG"):
		stats["DMG"] = ceilf(stats["DMG"] * factor)
	if stats.has("DMG_OVER_TIME"):
		stats["DMG_OVER_TIME"] = ceilf(stats["DMG_OVER_TIME"] * factor)
		
	return stats

static func addToStats(base : Dictionary, stats : Dictionary) -> Dictionary :
	var result = base.duplicate(true)
	
	for stat in stats.keys():
		if result.has(stat):
			if result[stat] is Dictionary and stats[stat] is Dictionary: ##base[stat] is Dictionary:
				result[stat] = addToStats(result[stat], stats[stat])
			elif stats[stat] is Array and stats[stat] is Array: ##base[stat] is Array:
				result[stat].append(stats[stat])
			else:
				result[stat] += stats[stat]
		else:
			result[stat] = stats[stat]
	return result
	

static func addToAttackStats(base : Dictionary, stats : Dictionary) -> Dictionary :
	var result = {"ATTACK" = base.get("ATTACK", {})}
		
	if stats && stats.has("ATTACK"):
		result["ATTACK"] = addToStats(result["ATTACK"], stats.get("ATTACK", {}))
	return result

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
