class_name GUtils

static func addToStats(base : Dictionary, stats : Dictionary) -> Dictionary :
	for stat in stats.keys():
		if base.has(stat):
			base[stat] += stats[stat]
	
	base.merge(stats)
	
	return base
	
static func addToAttackStats(base : Dictionary, stats : Dictionary) -> Dictionary :
	if stats.has("DMG"):
		addToStats(getOrCreateInDictionaryCategory(base, "DMG")["DMG"], stats["DMG"])
	if stats.has("STATUS"):
		addToStats(getOrCreateInDictionaryCategory(base, "STATUS")["STATUS"], stats["STATUS"])
	return base

static func getOrCreateInDictionaryCategory(dic : Dictionary, key : Variant):
	if dic.has(key):
		return dic[key]
	
	dic[key] = {}
	return dic
