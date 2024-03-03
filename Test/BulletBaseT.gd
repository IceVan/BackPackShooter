extends Area2D
class_name BulletBaseT

@export var maxDistance = 500.0
@export var speed = 10.0

var entityHit :Node2D
var direction = Vector2(0, 0)
var distanceTraveled = 0.0

func _process(delta):
	if(!isMaxDistanceReached() && direction.length() > 0):
		distanceTraveled += speed * delta
		move(delta)
	else:
		destroyBullet()
	
func move(delta):
	self.translate(direction * speed * delta)
	
	
func isMaxDistanceReached():
	return distanceTraveled >= maxDistance

func setCollisionMask(layers: Array, value: bool):
	for layer in layers:
		setCollisionMaskSingle(layer, value)


func setCollisionMaskSingle(layerNumber: int, value: bool):
	set_collision_mask_value(layerNumber, value)

func destroyBullet():
	self.queue_free()
	
func onHit(area):
	pass
