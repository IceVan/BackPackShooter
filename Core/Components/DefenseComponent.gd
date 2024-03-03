extends Node2D
class_name DefenseComponent

@onready var parent = get_parent()

func modifyAttack(attack: AttackResource) -> AttackResource:
	if !parent.stats.has("DEF"):
		return attack
		
	if attack.stats.has("DMG") :
		for key in attack.stats["DMG"].keys() :
			attack.stats["DMG"][key] \
			= maxi(attack.stats["DMG"][key] - getDefForKey(parent.stats["DEF"], key), 1)
			
	return attack

func getDefForKey(stats: Dictionary, key: Variant) -> int:
	return stats.get(key+400, 0) + stats.get(Enums.Tags.DEF_ALL, 0)
