extends SkillBase

@export var bullet : PackedScene

func processDirectionSkill(source : Entity, startLocation : Vector2, _targets : Array, _itemStats : Dictionary = {}) -> void:
	for target in _targets:
		if target is Vector2:
			createBullet(source, startLocation, target)
	
func processSkill(source : Entity, startLocation : Vector2, _targets : Array, _itemStats : Dictionary = {}) -> void:
	for entity in _targets:
		if entity is Entity:
			createBullet(source, startLocation, entity.global_position, _itemStats)

func createBullet(source : Entity, startLocation : Vector2, targetV2 : Vector2, itemStats : Dictionary = {}):
	var b = BulletManager.instantiateBullet(bullet, prepareAttack(source, itemStats), startLocation, (targetV2 - startLocation).normalized())
	if(source.isPlayer()):
		b.setCollisionLayer([6], true)
		b.setCollisionMask([2,3], true)
	else:
		b.setCollisionLayer([5], true)
		b.setCollisionMask([2,4], true)
	
