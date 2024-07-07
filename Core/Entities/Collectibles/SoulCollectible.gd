extends Collectible
class_name SoulCollectible

@export var soulValue : int = 1

signal soulCollected

func canBeCollected(collectedBy : Entity) -> bool: 
	return collectedBy.isPlayer()

func onCollect(_colectedBy : Entity):
	soulCollected.emit(soulValue)
	queue_free()

func _on_hitbox_component_area_entered(area):
	if(area is HitboxComponent and canBeCollectedWrapper(area.parentEntity)):
		onCollect(area.parentEntity)
