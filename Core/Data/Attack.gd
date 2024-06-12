extends Resource
class_name AttackResource

@export var enemy : bool = false
var source : Entity
@export var stats : Dictionary = {}
@export var tags : Array[Enums.Tags] = []

func _init(cstats : Dictionary = {}, ctags : Array[Enums.Tags] = []):
	stats = cstats
	tags = ctags
	
func toString() -> String:
	var toRet : String = "Enemy : %s \n" % str(enemy)
	toRet += "Tags: %s \n" % str(tags)
	toRet += "Stats: %s" % stats
	return toRet
