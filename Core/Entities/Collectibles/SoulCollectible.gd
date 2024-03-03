extends Collectible
class_name SoulCollectible

func canBeCollected(collectedBy : Entity) -> bool: 
	return collectedBy.isPlayer()

func onCollect(colectedBy : Entity):
	print("Collected!")
	queue_free()

func _on_hitbox_component_area_entered(area):
	if(area is HitboxComponent and canBeCollectedWrapper(area)):
		area.onTrigger(area)
