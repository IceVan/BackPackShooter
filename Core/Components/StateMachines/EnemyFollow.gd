extends State
class_name EnemyFollow

@export var entity : Entity
var followedEntity : Entity

@export var bonusSpeed : int = 0
@export var followRangePossibleError : float = 1.0
@export var followRange : float = 400.0
@export var minFollowDistance : float = 150.0


func enter():
	followedEntity = get_tree().get_first_node_in_group("Player")
	
func exit():
	pass
	
func update(_delta):
	pass
	
func physicsUpdate(_delta):
	var dir = followedEntity.global_position - entity.global_position
	var dirLengthSqr = dir.length_squared()
	
	
	if (dirLengthSqr < pow((minFollowDistance - followRangePossibleError), 2)):
		entity.velocity = -dir.normalized() * (GUtils.getNmericProperty(entity.stats, "STATS", "SPEED", 100) + bonusSpeed)
	elif (dirLengthSqr < pow((minFollowDistance + followRangePossibleError),2)):
		entity.velocity = Vector2.ZERO
	elif dirLengthSqr < pow(followRange, 2):
		entity.velocity = dir.normalized() * (GUtils.getNmericProperty(entity.stats, "STATS", "SPEED", 100) + bonusSpeed)
	else:
		Transitioned.emit(self, "ENEMYIDLE")
