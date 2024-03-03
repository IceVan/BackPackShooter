extends CharacterBody2D
class_name PlayerT


const SPEED = 300.0

@export var nRangedWeapon: RangedWeaponT

@onready var nCamera = get_node("Camera2D")
@onready var nPlayer = self

func _physics_process(delta):
	processInput(delta)

func destroy():
	print("destroy")
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func processInput(delta):
	if(nPlayer is PlayerT):		
		var direction_x = Input.get_axis("LEFT", "RIGHT")
		var direction_y = Input.get_axis("UP", "DOWN")
		nPlayer.velocity.x = 0
		nPlayer.velocity.y = 0

		# movement is handled like this
		if direction_x:
			nPlayer.velocity.x = direction_x * SPEED
		if direction_y:
			nPlayer.velocity.y = direction_y * SPEED
			
		nCamera.set("offset", Vector2(0, 0))
		# look at mouse
		self.look_at(get_global_mouse_position())
		
		nPlayer.move_and_slide()
			
		if(Input.get_action_raw_strength("ACTION_1") && nRangedWeapon.has_method("shoot")):
			nRangedWeapon.shoot();

