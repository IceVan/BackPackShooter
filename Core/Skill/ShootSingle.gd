extends SkillBase

@export var bullet : PackedScene

func processDirectionSkill(source : Entity, startLocation : Vector2, _targets : Array, _itemStats : Dictionary = {}) -> void:
	for target in _targets:
		if target is Vector2:
			createBullet(source, startLocation, target, prepareAttack(source, _itemStats))
	
func processSkill(source : Entity, startLocation : Vector2, _targets : Array, _itemStats : Dictionary = {}) -> void:
	for entity in _targets:
		if entity is Entity:
			createBullet(source, startLocation, entity.global_position, prepareAttack(source, _itemStats))

func processStaticSkill(source : Entity, startLocation : Vector2, _targets : Array, attackData : AttackResource = null) -> void:
	for entity in _targets:
		if entity is Entity:
			createBullet(source, startLocation, entity.global_position, attackData)
	
func processStaticDirectionSkill(source : Entity, startLocation : Vector2, _targets : Array, attackData : AttackResource = null) -> void:
	for target in _targets:
		if target is Vector2:
			createBullet(source, startLocation, target, attackData)


func createBullet(source : Entity, startLocation : Vector2, targetV2 : Vector2, attackData : AttackResource):
	var b = BulletManager.instantiateBullet(bullet, attackData, startLocation, (targetV2 - startLocation).normalized())
	var origin = attackData.stats.get("TRIGGERED_FROM", null)
	if origin:
		b.ignorableAreas.append(origin)
	if(source.isPlayer()):
		b.setCollisionLayer([6], true)
		b.setCollisionMask([2,3], true)
	else:
		b.setCollisionLayer([5], true)
		b.setCollisionMask([2,4], true)
	
