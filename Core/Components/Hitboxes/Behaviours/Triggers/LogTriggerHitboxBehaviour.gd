extends TriggerHitboxBehaviour
class_name LogTriggerHitboxBehaviour

func processBehaviour(parentEntity: Entity, collisionObject: Node2D):
	print("Collected ", collisionObject.name)
