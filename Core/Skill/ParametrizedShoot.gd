extends SkillBase
class_name ParametrizedShoot

@export var bullet : PackedScene
#TODO number of attacks
@export var numberOfAttacks : int = 1
@export var delayBetweenAttacks : float = 0.1
@export var numberOfProjectilesPerAttack : int = 1
@export var angle : float = 0.0

func staticUse(source : Entity, startLocation : Vector2, targets : Array, attackData : AttackResource = null) -> void:
	var sNumberOfAttacks = attackData.stats.get("SKILL",{}).get("SKILL_PARAMETRIZES_SHOOT_NUMBER_OF_ATTACKS", 1)
	var sDelayBetweenAttacks = max(attackData.stats.get("SKILL",{}).get("SKILL_DELAY_BETWEEN_ATTACKS", 0.1), 0.1)
	var sNumberOfProjectilesPerAttack = attackData.stats.get("SKILL",{}).get("SKILL_PARAMETRIZES_SHOOT_NUMBER_OF_PROJECTILES_PER_ATTACK", 1)
	var sAngle = attackData.stats.get("SKILL",{}).get("SKILL_PARAMETRIZES_SHOOT_ANGLE", 0.0)
	
	var trg = targets if targets.size() > 0 else getTargets(source, startLocation, attackData.stats.get("TARGETTING", "RANDOM"), true)
	if(trg.size() > 0 && trg[0] is Entity):
		for entity in trg:
			if entity is Entity:
				var entityPosition = entity.global_position
				for n in sNumberOfAttacks:
					if(n > 0): await get_tree().create_timer(sDelayBetweenAttacks).timeout
					var direction = (entityPosition - startLocation).normalized().rotated(-deg_to_rad(sAngle/2))
					for i in sNumberOfProjectilesPerAttack:
						createBullet(source, startLocation, entityPosition, direction, attackData)
						direction = direction.rotated(deg_to_rad(sAngle/sNumberOfProjectilesPerAttack))
	elif(trg.size() > 0 && trg[0] is Vector2):
		for target in trg:
			if target is Vector2:
				for n in sNumberOfAttacks:
					if(n > 0): await get_tree().create_timer(sDelayBetweenAttacks).timeout
					var direction = (target - startLocation).normalized().rotated(-deg_to_rad(sAngle/2))
					for i in sNumberOfProjectilesPerAttack:
						createBullet(source, startLocation, target, direction, attackData)
						direction = direction.rotated(deg_to_rad(sAngle/sNumberOfProjectilesPerAttack))
		

func processDirectionSkill(source : Entity, startLocation : Vector2, _targets : Array, _itemStats : Dictionary = {}) -> void:
	for target in _targets:
		if target is Vector2:
			for n in numberOfAttacks:
				if(n > 0): await get_tree().create_timer(delayBetweenAttacks).timeout
				var direction = (target - startLocation).normalized().rotated(-deg_to_rad(angle/2))
				for i in numberOfProjectilesPerAttack:
					createBullet(source, startLocation, target, direction, prepareAttack(source, _itemStats))
					direction = direction.rotated(deg_to_rad(angle/numberOfProjectilesPerAttack))
	
func processSkill(source : Entity, startLocation : Vector2, _targets : Array, _itemStats : Dictionary = {}) -> void:
	for entity in _targets:
		if entity is Entity:
			var entityPosition = entity.global_position
			for n in numberOfAttacks:
				if(n > 0): await get_tree().create_timer(delayBetweenAttacks).timeout
				var direction = (entityPosition - startLocation).normalized().rotated(-deg_to_rad(angle/2))
				for i in numberOfProjectilesPerAttack:
					createBullet(source, startLocation, entityPosition, direction, prepareAttack(source, _itemStats))
					direction = direction.rotated(deg_to_rad(angle/numberOfProjectilesPerAttack))

#TODO przpisać na to?
func processStaticSkill(_source : Entity, startLocation : Vector2, _targets : Array, attackData : AttackResource = null) -> void:
	pass
	
func processStaticDirectionSkill(_source : Entity, startLocation : Vector2, _targets : Array, attackData : AttackResource = null) -> void:
	pass


func createBullet(source : Entity, startLocation : Vector2, targetV2 : Vector2, direction : Vector2, attackData : AttackResource):
	var b = BulletManager.instantiateBullet(bullet, attackData, startLocation, direction)
	var origin = attackData.stats.get("TRIGGERED_FROM", null)
	if origin:
		b.ignorableAreas.append(origin)
	if(source.isPlayer()):
		b.setCollisionLayer([6], true)
		b.setCollisionMask([2,3], true)
	else:
		b.setCollisionLayer([5], true)
		b.setCollisionMask([2,4], true)
