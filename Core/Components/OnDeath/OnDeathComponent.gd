extends Node2D
class_name OnDeathComponent

@onready var parent : Entity = get_parent()

var behaviours : Array[OnDeathBehaviour] = []

func _ready():
	for child in get_children():
		if child is OnDeathBehaviour:
			behaviours.append(child)
	behaviours.sort_custom(func(a,b): a.priority > b.priority)

func processDeath():
	for behaviour in behaviours:
		behaviour.process(parent)
