extends Node
class_name CollectibleMagnesComponent

@export var range_ : float = 200.0
@export var magnesStrength : float = 1.0
@export var parentEntity : Entity

@onready var collectiblesNode = get_tree().current_scene.currentScene.get_node("Collectibles")


func onUpdate(delta):
	for child in collectiblesNode.get_children():
		if child is Collectible and parentEntity and child.canBeCollected(parentEntity):
			var dir = parentEntity.global_position - child.global_position
			
			if dir.length() < range_:
				child.global_position += dir * delta * log(magnesStrength/max(child.weight,0.01) +1)/log(10)
	
