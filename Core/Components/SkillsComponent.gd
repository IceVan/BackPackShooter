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
				
				var skillNode = SkillManager.createSkill(skill.get("SKILL_NAME",""), skill)
				
				if skillNode:
					
					skillNode.associatedItem = item
					var actionButton = skill.get("SKILL_ACTION_BUTTON","AUTO")
					if !skills.has(actionButton):
						skills[actionButton] = []
					skills[actionButton].append(skillNode)
					skillNode.autoTarget = !get_parent().isPlayer() && !skillNode.blockManualTarget
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
		
		
func swithAutoTarget():
	for key in skills.keys():
			for skill in skills.get(key, []):
				skill.autoTarget = !skill.autoTarget && !skill.blockManualTarget
	
func useAllActionSkills(action : String):
	if (action == "ALL"):
		for key in skills.keys():
			for skill in skills.get(key, []):
				skill.use(parent)
	else:
		for skill in skills.get(action, []):
			skill.use(parent)
		
func getOwnerPosition():
	return get_parent().position
