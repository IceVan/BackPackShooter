extends Area2D
class_name HitboxComponent

@export var parentEntity : Entity

func onHit(bullet : BaseBullet, attack : AttackResource):
	for child in get_children():
		if(child is BulletHitboxBehaviour):
			child.processBehaviour(parentEntity, bullet, attack)

func onTrigger(collisionObject: Node2D):
	for child in get_children():
		if(child is TriggerHitboxBehaviour):
			child.processBehaviour(parentEntity, collisionObject)


func _on_area_entered(_area):
	pass # Replace with function body.
