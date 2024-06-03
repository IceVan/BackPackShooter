extends State
class_name EnemyFollow

@export var entity : Entity
var followedEntity : Entity

var action1 : Array = []
var action2 : Array = []

@export var bonusSpeed : int = 0
@export var followRangePossibleError : float = 1.0
@export var followRange : float = 400.0
@export var minFollowDistance : float = 150.0

func _ready():
	prepareSkills()

func enter(val = null):
	if(action1.is_empty() && action2.is_empty()):
		prepareSkills()
	followedEntity = get_tree().get_first_node_in_group("Player")
	
func exit(val = null):
	pass
	
func update(_delta):
	pass
	
func physicsUpdate(_delta):
	var dir = followedEntity.global_position - entity.global_position
	var dirLengthSqr = dir.length_squared()
	
	for skill in action1:
		if(skill && \
		   skill.isReady && \
		   dirLengthSqr < pow(skill.maxRange,2) && \
		   dirLengthSqr > pow(skill.minRange,2)):
			print_debug("1st: ", dirLengthSqr < pow(skill.maxRange,2), " 2nd: ", dirLengthSqr > pow(skill.minRange,2))
			print_debug("LEN: ", dirLengthSqr, " MAX: ", pow(skill.maxRange,2), " MIN: ", pow(skill.minRange,2))
			print_debug("DATA: ", skill)
			Transitioned.emit(self, "ENEMYATTACKMELEE", skill)
			
	for secondarySkill in action2:
		if(secondarySkill && \
		   secondarySkill.isReady && \
		   dirLengthSqr < pow(secondarySkill.maxRange,2) && \
		   dirLengthSqr > pow(secondarySkill.minRange,2)):
			Transitioned.emit(self, "ENEMYATTACKMELEE", secondarySkill)
	
	if (dirLengthSqr < pow((minFollowDistance - followRangePossibleError), 2)):
		entity.velocity = -dir.normalized() * (GUtils.getNmericProperty(entity.stats, "STATS", "SPEED", 100) + bonusSpeed)
	elif (dirLengthSqr < pow((minFollowDistance + followRangePossibleError),2)):
		entity.velocity = Vector2.ZERO
	elif dirLengthSqr < pow(followRange, 2):
		entity.velocity = dir.normalized() * (GUtils.getNmericProperty(entity.stats, "STATS", "SPEED", 100) + bonusSpeed)
	else:
		Transitioned.emit(self, "ENEMYIDLE")

func prepareSkills():
	#TODO sprawdzic czy nie za czesto sie wywoluje
	#print_debug(entity.skillsComponent.skills)
	action1 = entity.skillsComponent.skills.get("ACTION_1", [])
	action2 = entity.skillsComponent.skills.get("ACTION_2", [])
