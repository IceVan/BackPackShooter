extends Node2D
class_name SkillBase

@export var autoTimer : Timer
@export var cooldown : float = 1.0
@export var autoUse : bool = false
@export var autoTarget : bool = true
@export var blockManualTarget : bool = false


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

func prepareAttack(source : Entity, itemStats : Dictionary = {}) -> AttackResource:
	var attack = AttackResource.new()
	attack.source = source
	attack.tags = tags
	attack.stats = \
		GUtils.addToAttackStats(\
			{"ATTACK" = source.stats.get("ATTACK",{}).duplicate(true)},\
			itemStats if !itemStats.is_empty() else associatedItem.stats)
	attack.stats = modifyAttack(attack.stats)
	attack.stats = GUtils.addToStats(attack.stats, stats)
	return attack

func modifyAttack(stats : Dictionary) -> Dictionary:
	if stats.get("ATTACK",{}).has("DMG"):
		stats.get("ATTACK",{})["DMG"] = ceilf(stats.get("ATTACK",{})["DMG"] * multiplicationFactor) + flatBonus
	if stats.get("ATTACK",{}).has("DMG_OVER_TIME"):
		stats.get("ATTACK",{})["DMG_OVER_TIME"] = ceilf(stats.get("ATTACK",{})["DMG_OVER_TIME"] * dotMultiplicationFactor) + dotFlatBonus
	
	return stats

func processSkill(_source : Entity, startLocation : Vector2, _targets : Array[Entity], _itemStats : Dictionary = {}) -> void:
	pass
	
func processDirectionSkill(_source : Entity, startLocation : Vector2, _targets : Array[Vector2], _itemStats : Dictionary = {}) -> void:
	pass

func processStaticSkill(_source : Entity, startLocation : Vector2, _targets : Array, attackData : AttackResource = null) -> void:
	pass
	
func processStaticDirectionSkill(_source : Entity, startLocation : Vector2, _targets : Array, attackData : AttackResource = null) -> void:
	pass


func getTargets(_source : Entity, startLocation : Vector2, type : String, forceAuto : bool = false) -> Array:
	if(_source.isPlayer()):
		if(autoTarget || blockManualTarget || forceAuto):
			if(type == "CLOSEST"):
				var closestEntity = null
				var closestDist_sqr = pow(maxRange, 2)
				for entity in get_tree().get_nodes_in_group("Enemy"):
					var length_sqr = (startLocation - entity.global_position).length_squared()
					if length_sqr > 0 && length_sqr < closestDist_sqr:
						closestEntity = entity
						closestDist_sqr = length_sqr
						
				if(closestEntity != null):
					return [closestEntity]
			elif type == "RANDOM":
				return [Vector2(startLocation.x + randf_range(-1,1), startLocation.y + randf_range(-1,1))]
		else:
			return [_source.controllComponent.getCursorPosition()]
	else:
		return get_tree().get_nodes_in_group("Player")
		
	return []
	
func _ready():
	autoTimer.wait_time = cooldown
	autoTimer.one_shot = !autoUse
	
func use(source : Entity, targets : Array = []) -> void:
	assert(associatedItem)
	if(!caster):
		caster = source
	if(isReady):
		var trg = targets if targets.size() > 0 else getTargets(caster, caster.global_position, "CLOSEST")
		if(trg.size() > 0 && trg[0] is Entity):
			processSkill(caster, caster.global_position, trg)
		elif(trg.size() > 0 && trg[0] is Vector2):
			processDirectionSkill(caster, caster.global_position, trg)
		isReady = false
		autoTimer.start()

func staticUse(source : Entity, startLocation : Vector2, targets : Array, attackData : AttackResource = null) -> void:
	var trg = targets if targets.size() > 0 else getTargets(source, startLocation, attackData.stats.get("TARGETTING", "RANDOM"), true)
	if(trg.size() > 0 && trg[0] is Entity):
		processStaticSkill(source, startLocation, trg, attackData)
	elif(trg.size() > 0 && trg[0] is Vector2):
		processStaticDirectionSkill(source, startLocation, trg, attackData)
	
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
