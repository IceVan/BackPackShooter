extends Node2D
class_name Collectible

var BASSE_SPEED : float = 100
@export var weight : float = 1.0

func onCollect(colectedBy : Entity):
	pass

func canBeCollected(collectedBy : Entity) -> bool: 
	return true

func canBeCollectedWrapper(collectedBy : Node2D) -> bool: 
	if collectedBy is Entity:
		return canBeCollected(collectedBy)
	else:
		return false
