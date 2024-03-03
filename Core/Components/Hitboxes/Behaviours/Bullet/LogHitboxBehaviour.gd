extends BulletHitboxBehaviour
class_name LogHitboxBehaviour

func logHit(parentEntity: Entity, attack: AttackResource):
	print(parentEntity.name + " " + attack.toString())
		
func processBehaviour(parentEntity: Entity, bullet : BaseBullet, attack : AttackResource):
	logHit(parentEntity, attack)
