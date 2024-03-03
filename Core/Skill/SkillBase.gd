extends Node2D
class_name SkillBase

@export var skillData : SkillResource

@export var autoTimer : Timer
@export var cooldown : float = -1
@export var autoUse : bool = false

var isReady : bool = true  
var caster : Entity = null

func prepareAttack(source : Entity) -> AttackResource:
	var attack = AttackResource.new()
	attack.tags = skillData.tags
	attack.stats = GUtils.addToAttackStats(source.stats.duplicate(true), skillData.stats)
	return attack

func processSkill(source : Entity, targets : Array[Entity]) -> void:
	pass
	
func getTargets(source : Entity) -> Array[Entity]:
	return []
	
func _ready():
#	assert(self.get_parent().component)
#	caster = get_parent().component.get_parent()
	if(skillData.cooldown):
		cooldown = skillData.cooldown
	autoTimer.wait_time = cooldown
	autoTimer.one_shot = !autoUse
	
func use(source : Entity) -> void:
	if(!caster):
		caster = source
	if(isReady):
		processSkill(caster, getTargets(caster))
		isReady = false
		autoTimer.start()

func _on_timer_timeout():
	isReady = true
	if(autoUse):
		use(caster)
		
func start(source : Entity = caster):
	use(caster)
	
func stop():
	autoTimer.stop()
	
func pause(paused : bool = true):
	autoTimer.paused = paused
	
#TO-REMOVE?
func useIfTagMatch(source : Entity, tag : Enums.Tags):
	if(tag in skillData.tags):
		use(source)
