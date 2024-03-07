extends State
class_name EnemyIdle

@export var entity : Entity
var followedEntity : Entity

@export var followRange : int = 100

var moveDirection : Vector2
var wanderTime : float

func randomizeWander():
	moveDirection = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wanderTime = randf_range(1,2)

func enter():
	followedEntity = get_tree().get_first_node_in_group("Player")
	randomizeWander()
	
func update(delta : float):
	if wanderTime > 0:
		wanderTime -= delta
	else:
		randomizeWander()
		
func physicsUpdate(_delta : float):
	if entity:
		entity.velocity = moveDirection * (entity.baseSpeed + entity.stats.get(Enums.Tags.SPEED,0))
	
	if (followedEntity.global_position - entity.global_position).length() <= followRange:
		Transitioned.emit(self, "ENEMYFOLLOW") 
