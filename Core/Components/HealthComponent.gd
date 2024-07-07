extends Node2D
class_name HealthComponent

const MIN_HP = 1
#@export var healthBar: HealthBar

@export var maxHealth = MIN_HP
@export var passiveRegeneration : float = 0
var currentRegenCounter : float = 0 

@export var maximumOverTimeStatuses = 5

@onready var parent = get_parent()
@export var overTimeTimer : HealthOverTimeTimer

signal healthChanged(old_health, new_health)
signal maxHealthChanged(maxHealth)
signal died

var currentHealth 

func _ready():
	var maxHP = GUtils.getNmericProperty(parent.baseStats, "STATS", "MAX_HP") \
	+ GUtils.getNmericProperty(parent.stats, "STATS", "MAX_HP") if get_parent() is Entity else MIN_HP
	changeMaxHealth(maxHP)
	currentHealth = maxHealth
	
	passiveRegeneration = GUtils.getFloatingProperty(parent.baseStats, "STATS", "REGENERATION")

func damage(attack: AttackResource, includeDot: bool = true):
	if(GUtils.getNmericProperty(attack.stats, "ATTACK", "DMG") > 0):
		var oldHealth : int
		
		oldHealth = currentHealth
		currentHealth = max(currentHealth - GUtils.getNmericProperty(attack.stats, "ATTACK", "DMG"), 0)
		healthChanged.emit(oldHealth, currentHealth)
		
		#Damage Over Time
		#TODO Tags
		var dot = GUtils.getNmericProperty(attack.stats, "ATTACK", "DMG_OVER_TIME")
		if(includeDot && dot > 0):
			overTimeTimer.addData(dot, GUtils.getNmericProperty(attack.stats, "ATTACK", "DMG_OVER_TIME_DURATION", 10))

		#if !get_parent().isPlayer() and !attack.enemy:
			#ShowStatistics.addDamageDealt(dmg, oldHealth-currentHealth)
		ShowStatistics.updatePlayerHealth(self)
		
		if(currentHealth <= 0 && get_parent().has_method("destroy")):
			died.emit()
			
func isAlive() -> bool:
	return currentHealth > 0

func fullyRegenerate():
	var oldHealth = currentHealth
	currentHealth = maxHealth
	healthChanged.emit(oldHealth, currentHealth)
	ShowStatistics.updatePlayerHealth(self)	
#	updateHealthBar(healthBar, currentHealth)
	

func passiveRegenerate():
	currentRegenCounter = currentRegenCounter + passiveRegeneration
	if(currentHealth >= 1):
		regenerate(floori(currentRegenCounter))
		currentRegenCounter = currentRegenCounter - floori(currentRegenCounter)
	
func regenerate(hp : int):
	if(hp > 0):
		var oldHealth = currentHealth
		currentHealth = min(maxHealth, currentHealth + hp)
		healthChanged.emit(oldHealth, currentHealth)
		ShowStatistics.updatePlayerHealth(self)
#		updateHealthBar(healthBar, currentHealth)

func changeMaxHealth(aMaxHealth : int):
	if aMaxHealth > MIN_HP: 
		var diff = aMaxHealth - maxHealth
		maxHealth = aMaxHealth
		maxHealthChanged.emit(maxHealth)
		if diff > 0 : regenerate.call_deferred(diff)
