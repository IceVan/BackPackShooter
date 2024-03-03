extends Node2D
class_name RangedWeaponT

var shootTimer = 0.0
#number of attacks per sec
@export var shootRate = 4.0
@export var bullet: PackedScene

#@onready var bulletsNode = get_node("/root/Game/Bullets")

func isTimerReady():
	return shootTimer >= 1/shootRate
	
func resetTimer():
	shootTimer = 0.0

func _process(delta):
	shootTimer = minf(1.0/shootRate, shootTimer + delta)

func shoot():
	if(isTimerReady()):
		instantiateBulletT()
		resetTimer()

func instantiateBullet():
	var b = bullet.instantiate()
	
	add_child(b)
	b.global_position = get_parent().get("global_position")
	b.set("direction", (get_global_mouse_position() - self.global_position).normalized())
	#b.setCollisionMask([1,3], true)
	
func instantiateBulletT():
	var b = BulletManager.instantiateBullet(bullet, global_position, (get_global_mouse_position() - global_position).normalized())
	#b.setCollisionMask([1,3], true)
	b.move_to_front()
