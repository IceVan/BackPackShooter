extends Node2D
class_name Collectible

var BASSE_SPEED : float = 100
@export var weight : float = 1.0

func onCollect(_colectedBy : Entity):
	pass

func canBeCollected(_collectedBy : Entity) -> bool: 
	return true

func canBeCollectedWrapper(collectedBy : Node2D) -> bool: 
	return canBeCollected(collectedBy) if collectedBy is Entity else false
