extends Resource
class_name AttackResource

@export var enemy : bool = false
@export var stats : Dictionary = {}
@export var tags : Array[Enums.Tags] = []

func toString() -> String:
	var toRet : String = "Enemy : %s \n" % str(enemy)
	toRet += "Tags: %s \n" % str(tags)
	toRet += "Stats: %s" % stats
	return toRet
