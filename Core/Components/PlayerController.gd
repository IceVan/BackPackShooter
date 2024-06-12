extends ControllComponent
class_name PlayerController

#@export var nDodgeComponent: DodgeComponent
#@export var nRangedWeapon: RangedWeapon
@export var autoAttack = true

@onready var nCamera = get_parent().get_node("Camera2D")
@onready var nPlayer : Entity = get_parent()
var speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = GUtils.getNmericProperty(nPlayer.stats, "STATS", "SPEED", 100)
	autoTarget = false
	#DisplayServer.window_get_size()
	#get_viewport().get_visible_rect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func processInput(_delta):
	var direction_x = Input.get_axis("LEFT", "RIGHT")
	var direction_y = Input.get_axis("UP", "DOWN")

	nPlayer.velocity = Vector2(direction_x, direction_y).normalized() * speed
		
	var cursorPosition = getCursorPosition()
	
	nCamera.set("offset", calculateCameraOffset(cursorPosition, DisplayServer.window_get_size()))
	nCamera.set("zoom", Vector2(0.5, 0.5))
	# look at mouse
	self.look_at(cursorPosition)
	
	if(Input.get_action_raw_strength("AUTO_TARGET")):
		nPlayer.skillsComponent.swithAutoTarget()
				
	if(autoAttack):
		nPlayer.skillsComponent.useAllActionSkills("ALL")
	else:
		if(Input.get_action_raw_strength("ACTION_1")):
			nPlayer.skillsComponent.useAllActionSkills("ACTION_1")
			
		if(Input.get_action_raw_strength("ACTION_2")):
			nPlayer.skillsComponent.useAllActionSkills("ACTION_2")
		
		if(Input.get_action_raw_strength("ACTION_3")):
			nPlayer.skillsComponent.useAllActionSkills("ACTION_3")
		
		if(Input.get_action_raw_strength("DODGE")):
			nPlayer.skillsComponent.useAllActionSkills("DODGE")
		
		if(Input.get_action_raw_strength("USE")):
			nPlayer.skillsComponent.useAllActionSkills("USE")
		
		if(Input.get_action_raw_strength("RELOAD")):
			nPlayer.skillsComponent.useAllActionSkills("RELOAD")
		
func getCursorPosition():
	return get_global_mouse_position()
	
func calculateCameraOffset(cursorPosition : Vector2, displaySize : Vector2) -> Vector2 :
	return Vector2(\
		(cursorPosition.x - global_position.x)/(displaySize.x/64.0),\
		(cursorPosition.y - global_position.y)/(displaySize.y/64.0),\
	)
