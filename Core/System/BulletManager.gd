extends Node

@export var bullets : Array[PackedScene] = []


func _process(delta):
	pass

func instantiateBullet(bullet : PackedScene, \
	attackData : AttackResource, \
	#source : Entity, \
	spawnPointGlobalPosition : Vector2, \
	direction : Vector2 = Vector2(0,0)) -> Area2D:
		
	var b = bullet.instantiate()
	b.global_position = spawnPointGlobalPosition
	b.direction = direction
	b.attackData = attackData
	self.add_child(b)
	bullets.append(b)
	b.move_to_front()
	#Sprint_debug(b.global_position, " - ", b.direction)
	return b
