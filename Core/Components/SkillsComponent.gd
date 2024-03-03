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
		for item in get_parent().getItems(false):
			for skill in item.skills:
				var skillNode = SkillToSceneDictionary.fromEnum[skill.type].instantiate()
				skillNode.skillData.stats = skill.stats
				for actionButton in skill.actionButtons:
					if !skills.has(actionButton):
						skills[actionButton] = []
					skills[actionButton].append(skillNode)
				self.add_child(skillNode)
	print_debug(get_parent().getItems())
	print_debug(skills)


func startAll(source : Entity = get_parent()):
	for action in skills:
		for skill in skills[action]:
			skill.use(source)

func stopAll():
	for action in skills:
		for skill in skills[action]:
			skill.stop()
		
func pauseAll(paused : bool = true):
	for action in skills:
		for skill in skills[action]:
			skill.pause(paused)
		
func useAllActionSkills(action : Enums.ActionButton):
	print_debug(skills)
	for skill in skills.get(action, []):
		skill.use(parent)
		
func getOwnerPosition():
	return get_parent().position
