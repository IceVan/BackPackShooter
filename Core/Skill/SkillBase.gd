extends Node2D
class_name SkillBase

@export var autoTimer : Timer
@export var cooldown : float = 1.0
@export var autoUse : bool = false

#AI STUFF
@export var minRange : int = 0
@export var maxRange : int = 0

#SKILL BONUSES
@export var multiplicationFactor : float = 1.0
@export var dotMultiplicationFactor : float = 1.0
@export var flatBonus : int = 0
@export var dotFlatBonus : int = 0

@export var type : Enums.Skills
@export var tags : Array[Enums.Tags] = []
@export var stats : Dictionary = {}
@export var skillChain : Dictionary = {}

var isReady : bool = true  
var caster : Entity = null
var associatedItem : Item = null

func prepareAttack(source : Entity, item : Item = null) -> AttackResource:
	var attack = AttackResource.new()
	attack.tags = tags
	attack.stats = GUtils.addToAttackStats({"ATTACK" = source.stats.get("ATTACK",{}).duplicate(true)}, item.stats if item else {})
	attack.stats = modifyAttack(attack.stats)
	return attack

func modifyAttack(stats : Dictionary) -> Dictionary:
	if stats.get("ATTACK",{}).has("DMG"):
		stats.get("ATTACK",{})["DMG"] = ceilf(stats.get("ATTACK",{})["DMG"] * multiplicationFactor) + flatBonus
	if stats.get("ATTACK",{}).has("DMG_OVER_TIME"):
		stats.get("ATTACK",{})["DMG_OVER_TIME"] = ceilf(stats.get("ATTACK",{})["DMG_OVER_TIME"] * dotMultiplicationFactor) + dotFlatBonus
	
	return stats

func processSkill(_source : Entity, _targets : Array, _item : Item = null) -> void:
	pass
	
func getTargets(_source : Entity) -> Array:
	return []
	
func _ready():
#	assert(self.get_parent().component)
#	caster = get_parent().component.get_parent()

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
	if(tag in tags):
		use(source)
