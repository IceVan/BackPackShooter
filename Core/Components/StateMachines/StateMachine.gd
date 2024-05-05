extends Node
class_name StateMachine

@export var initialState : State

var currentState : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_upper()] = child
			child.Transitioned.connect(onStateTransition)
	
	if initialState:
		initialState.enter()
		currentState = initialState

func _process(delta):
	if currentState :
		currentState.update(delta)

func _physics_process(delta):
	if currentState :
		currentState.physicsUpdate(delta)
	
func onStateTransition(state, newStateName, val = null):
	if state != currentState:
		return
		
	var newState = states.get(newStateName.to_upper())
	if !newState:
		return
		
	if currentState:
		currentState.exit(val)
	
	newState.enter(val)
	currentState = newState
