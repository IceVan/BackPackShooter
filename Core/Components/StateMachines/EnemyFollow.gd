extends State
class_name EnemyFollow

@export var entity : Entity
var followedEntity : Entity

@export var weapon : Item
@export var secondaryWeapon : Item

var skill : SkillBase
var secondarySkill : SkillBase

@export var bonusSpeed : int = 0
@export var followRangePossibleError : float = 1.0
@export var followRange : float = 400.0
@export var minFollowDistance : float = 150.0

func _ready():
	prepareSkills()

func enter(val = null):
	if(!skill):
		prepareSkills()
	followedEntity = get_tree().get_first_node_in_group("Player")
	
func exit(val = null):
	pass
	
func update(_delta):
	pass
	
func physicsUpdate(_delta):
	var dir = followedEntity.global_position - entity.global_position
	var dirLengthSqr = dir.length_squared()
	
	if(skill && \
	   skill.isReady && \
	   dirLengthSqr < pow(skill.skillData.maxRange,2) && \
	   dirLengthSqr > pow(skill.skillData.minRange,2)):
		Transitioned.emit(self, "ENEMYATTACKMELEE", skill)
	elif(secondarySkill && \
		 secondarySkill.isReady && \
		 dirLengthSqr < pow(secondarySkill.skillData.maxRange,2) && \
		 dirLengthSqr > pow(secondarySkill.skillData.minRange,2)):
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
	#TODO oprzec na action buttonach
	if weapon:
		var skillStat = weapon.stats.get("SKILLS", []).pop_front()
		var sceneResource = SkillToSceneDictionary.fromString.get(skillStat.get("SKILL_NAME", "") if skillStat else "")
		if sceneResource:
			skill = sceneResource.instantiate()
			skill.associatedItem = weapon
			self.add_child(skill)
	if secondaryWeapon:
		var sSkillStat = weapon.stats.get("SKILLS", []).pop_front()
		var sSceneResource = SkillToSceneDictionary.fromString.get(sSkillStat.get("SKILL_NAME", "") if sSkillStat else "")
		if sSceneResource:
			secondarySkill = sSceneResource.instantiate()
			secondarySkill.associatedItem = weapon
			self.add_child(secondarySkill)
