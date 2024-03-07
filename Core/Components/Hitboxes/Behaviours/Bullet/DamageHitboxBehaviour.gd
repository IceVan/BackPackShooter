extends BulletHitboxBehaviour
class_name DamageHitboxBehaviour

func damage(parentEntity: Entity, attack: AttackResource):
	if(parentEntity.healthComponent):
		parentEntity.recieveDamage(attack)
		
func processBehaviour(parentEntity: Entity, _bullet : BaseBullet, attack : AttackResource):
	damage(parentEntity, attack)
