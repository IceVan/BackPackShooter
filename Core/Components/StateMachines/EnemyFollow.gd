extends State
class_name EnemyFollow

@export var entity : Entity
var followedEntity : Entity

@export var bonusSpeed : int = 0
@export var followRange : int = 100

func enter():
	followedEntity = get_tree().get_first_node_in_group("Player")
	
func exit():
	pass
	
func update(_delta):
	pass
	
func physicsUpdate(_delta):
	var dir = followedEntity.global_position - entity.global_position
	
	entity.velocity = dir.normalized() * (entity.baseSpeed + entity.stats.get(Enums.Tags.SPEED,0) + bonusSpeed)
		
	if dir.length() > followRange:
		Transitioned.emit(self, "ENEMYIDLE")
