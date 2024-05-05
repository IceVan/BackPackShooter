extends Node2D
class_name SkillBase

@export var skillData : SkillResource

@export var autoTimer : Timer
var cooldown : float = -1
@export var autoUse : bool = false

var isReady : bool = true  
var caster : Entity = null
var associatedItem : Item = null

func prepareAttack(source : Entity, item : Item = null) -> AttackResource:
	var attack = AttackResource.new()
	attack.tags = skillData.tags
	attack.stats = GUtils.addToAttackStats(source.stats.duplicate(true), item.stats if item else {})
	attack.stats = modifyAttack(attack.stats)
	return attack

func modifyAttack(stats : Dictionary) -> Dictionary:
	
	#TODO 
	
	return stats

func processSkill(_source : Entity, _targets : Array, _item : Item = null) -> void:
	pass
	
func getTargets(_source : Entity) -> Array:
	return []
	
func _ready():
#	assert(self.get_parent().component)
#	caster = get_parent().component.get_parent()
	if(skillData.cooldown):
		cooldown = skillData.cooldown
	autoTimer.wait_time = cooldown
	autoTimer.one_shot = !autoUse
	
func use(source : Entity, item : Item = null) -> void:
	if(!caster):
		caster = source
	if(isReady):
		processSkill(caster, getTargets(caster), item)
		isReady = false
		autoTimer.start()

func _on_timer_timeout():
	isReady = true
	if(autoUse):
		use(caster)
		
func start(_source : Entity = caster):
	use(caster)
	
func stop():
	autoTimer.stop()
	
func pause(paused : bool = true):
	autoTimer.paused = paused
	
#TO-REMOVE?
func useIfTagMatch(source : Entity, tag : Enums.Tags):
	if(tag in skillData.tags):
		use(source)
