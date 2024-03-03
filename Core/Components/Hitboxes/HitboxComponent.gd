extends Area2D
class_name HitboxComponent

@export var paretnEntity : Entity

func onHit(bullet : BaseBullet, attack : AttackResource):
	for child in get_children():
		if(child is BulletHitboxBehaviour):
			child.processBehaviour(paretnEntity, bullet, attack)

func onTrigger(collisionObject: Node2D):
	for child in get_children():
		if(child is TriggerHitboxBehaviour):
			child.processBehaviour(paretnEntity, collisionObject)


func _on_area_entered(area):
	pass # Replace with function body.
