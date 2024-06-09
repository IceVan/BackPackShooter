extends SkillBase

@export var bullet : PackedScene

func processDirectionSkill(source : Entity, _targets : Array, _itemStats : Dictionary = {}) -> void:
	for target in _targets:
		if target is Vector2:
			createBullet(source, target)
	
func processSkill(source : Entity, _targets : Array, _itemStats : Dictionary = {}) -> void:
	#print_debug(get_tree().get_first_node_in_group("Player"))
	for entity in _targets:
		if entity is Entity:
			createBullet(source, entity.global_position, _itemStats)

func createBullet(source : Entity, targetV2 : Vector2, itemStats : Dictionary = {}):
	var b = BulletManager.instantiateBullet(bullet, prepareAttack(source, itemStats), global_position, (targetV2 - global_position).normalized())
	if(source.isPlayer()):
		b.setCollisionLayer([6], true)
		b.setCollisionMask([2,3], true)
	else:
		b.setCollisionLayer([5], true)
		b.setCollisionMask([2,4], true)
	
