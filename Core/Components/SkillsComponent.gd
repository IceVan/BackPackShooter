extends Node2D
class_name SkillsComponent

#struct: Enums.ActionButton : SkillBase
var skills : Dictionary = {}
var parent : Entity

func _ready():
	parent = get_parent()
	updateSkills()

func removeSkills() -> void :
	for child in get_children():
		if(child is SkillBase):
			self.remove_child(child)
			child.queue_free()
			
	skills = {}
	
func updateSkills(repopulate : bool = true):
	if(repopulate) :
		removeSkills()
	#for inventoryComponent -> items -> skills
	
	if(get_parent().inventoryComponent):
		for item in get_parent().getItems():
			for skill in item.stats.get("SKILLS", []):
				if !skill:
					continue
					
				var sceneResource = SkillToSceneDictionary.fromString.get(skill.get("SKILL_NAME",""), null)
				if sceneResource:
					var skillNode = sceneResource.instantiate()
					
					if(skill.has("SKILL_MULTIPLICATION_FACTOR")):
						skillNode.multiplicationFactor = skill.get("SKILL_MULTIPLICATION_FACTOR", 1.0)
					if(skill.has("SKILL_DOT_MULTIPLICATION_FACTOR")):
						skillNode.dotMultiplicationFactor = skill.get("SKILL_DOT_MULTIPLICATION_FACTOR", 1.0)
					if(skill.has("SKILL_FLAT_BONUS")):
						skillNode.flatBonus = skill.get("SKILL_FLAT_BONUS", 0)
					if(skill.has("SKILL_DOT_FLAT_BONUS")):
						skillNode.dotFlatBonus = skill.get("SKILL_DOT_FLAT_BONUS", 0)
					
					skillNode.associatedItem = item
					var actionButton = skill.get("SKILL_ACTION_BUTTON","AUTO")
					if !skills.has(actionButton):
						skills[actionButton] = []
					skills[actionButton].append(skillNode)
					self.add_child(skillNode)


func startAll(source : Entity = get_parent()):
	for skill in skills.get("AUTO", []):
		skill.use(source)

func stopAll():
	for action in skills:
		for skill in skills[action]:
			skill.stop()
		
func pauseAll(paused : bool = true):
	for action in skills:
		for skill in skills[action]:
			skill.pause(paused)
		
func useAllActionSkills(action : String):
	for skill in skills.get(action, []):
		skill.use(parent)
		
func getOwnerPosition():
	return get_parent().position
