extends SkillBase
class_name EnemyTargetedMelee1

func processSkill(_source : Entity, startLocation : Vector2, _targets : Array, _itemStats : Dictionary = {}) -> void:
	for target in _targets:
		if target.healthComponent:
			target.healthComponent.damage(prepareAttack(_source))
	
func getTargets(_source : Entity, startLocation : Vector2, forceAuto : bool = false) -> Array:
	#TODO add limit
	var entities = get_tree().get_nodes_in_group("Player")\
	.filter(func(node): return (node.global_position - startLocation).length() < maxRange)
	entities.sort_custom(func(n1, n2): return (n1.global_position - startLocation).length() < (n2.global_position - startLocation).length())
	print_debug("Targets: ", entities)
	return entities
