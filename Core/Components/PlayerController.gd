extends ControllComponent
class_name PlayerController

#@export var nDodgeComponent: DodgeComponent
#@export var nRangedWeapon: RangedWeapon

@onready var nCamera = get_parent().get_node("Camera2D")
@onready var nPlayer : Entity = get_parent()
var speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = nPlayer.baseSpeed + nPlayer.stats.get(Enums.Tags.SPEED,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func processInput(_delta):
	var direction_x = Input.get_axis("LEFT", "RIGHT")
	var direction_y = Input.get_axis("UP", "DOWN")
	nPlayer.velocity.x = 0
	nPlayer.velocity.y = 0

	# movement is handled like this
	if direction_x:
		nPlayer.velocity.x = direction_x * speed
	if direction_y:
		nPlayer.velocity.y = direction_y * speed
		
	nCamera.set("offset", Vector2(0, 0))
	nCamera.set("zoom", Vector2(0.5, 0.5))
	# look at mouse
	self.look_at(get_global_mouse_position())

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
