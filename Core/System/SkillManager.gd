extends Node

var skillsDictonary : Dictionary = {}

const preloadedResources = {\
	"SHOOT_SINGLE" : preload("res://Core/Skill/ShootSingle.tscn"),\
	"PARAMETRIZED_SHOOT" : preload("res://Core/Skill/ParametrizedShoot.tscn"),\
	"SHOOT_SERIE" : preload("res://Core/Skill/ShootSingle.tscn"),\
	
	"ENEMY_TARGETED_MELEE_1" : preload("res://Core/Skill/EnemyTargetedMelee1.tscn"),\
}

#"SHOOT_SINGLE" : preload("res://Core/Skill/ShootSingle.tscn"),\
	#"SHOOT_CONE" : preload("res://Core/Skill/ShootPaf.tscn"),\
	#"SHOOT_SERIE" : preload("res://Core/Skill/ShootSingle.tscn"),\
	#
	#"ENEMY_TARGETED_MELEE_1" : preload("res://Core/Skill/EnemyTargetedMelee1.tscn"),\
	
func _ready():
	for key in preloadedResources.keys():
		var skill = createSkill(key)
		skill.autoTarget = true
		skillsDictonary[key] = skill
		self.add_child(skill)

func _process(delta):
	pass

func createSkill(skillName : String, skillData : Dictionary = {}) -> SkillBase:
	var sceneResource = preloadedResources.get(skillName, null)
	if sceneResource:
		var skillNode = sceneResource.instantiate()
				
		if(skillData.has("SKILL_MULTIPLICATION_FACTOR")):
			skillNode.multiplicationFactor = skillData.get("SKILL_MULTIPLICATION_FACTOR", 1.0)
		if(skillData.has("SKILL_DOT_MULTIPLICATION_FACTOR")):
			skillNode.dotMultiplicationFactor = skillData.get("SKILL_DOT_MULTIPLICATION_FACTOR", 1.0)
		if(skillData.has("SKILL_FLAT_BONUS")):
			skillNode.flatBonus = skillData.get("SKILL_FLAT_BONUS", 0)
		if(skillData.has("SKILL_DOT_FLAT_BONUS")):
			skillNode.dotFlatBonus = skillData.get("SKILL_DOT_FLAT_BONUS", 0)
		if(skillData.has("SKILLS")):
			skillNode.stats["SKILLS"] = skillData.get("SKILLS", [])
		
		return skillNode
		#skillNode.associatedItem = item
		#var actionButton = skillData.get("SKILL_ACTION_BUTTON","AUTO")
		#if !skills.has(actionButton):
			#skills[actionButton] = []
		#skills[actionButton].append(skillNode)
		#skillNode.autoTarget = !get_parent().isPlayer() && !skillNode.blockManualTarget
		#self.add_child(skillNode)
	
	return null
	
func getSkill(skillName : String) -> SkillBase:
	return skillsDictonary.get(skillName, null)
	
func staticUse(skillName : String, source : Entity, startLocation : Vector2, targets : Array, attackData : AttackResource) -> void:
	var skill = getSkill(skillName)
	if skill:
		skill.staticUse(source, startLocation, targets, attackData)
