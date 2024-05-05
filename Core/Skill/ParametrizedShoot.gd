extends SkillBase
class_name ParametrizedShoot

@export var bullet : PackedScene

func processSkill(source : Entity, _targets : Array, _item : Item = null) -> void:
	var b = BulletManager.instantiateBullet(bullet, prepareAttack(source), global_position, (get_global_mouse_position() - global_position).normalized())
	
	if(source.isPlayer()):
		b.setCollisionLayer([6], true)
		b.setCollisionMask([2,3], true)
	else:
		b.setCollisionLayer([5], true)
		b.setCollisionMask([2,4], true)
