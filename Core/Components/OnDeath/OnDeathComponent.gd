extends Node2D
class_name OnDeathComponent

@onready var parent : Entity = get_parent()

func processDeath():
	for behaviour in get_children():
		if behaviour is OnDeathBehaviour: 
			behaviour.process(parent)
