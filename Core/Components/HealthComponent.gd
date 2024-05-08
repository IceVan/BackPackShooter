extends Node2D
class_name HealthComponent

const MIN_HP = 1
#@export var healthBar: HealthBar

@export var maxHealth = MIN_HP
@export var passiveRegeneration = 0
@export var maximumOverTimeStatuses = 10

@onready var parent = get_parent()

signal healthChanged(old_health, new_health)
signal died

var currentHealth 

func _ready():
	maxHealth = GUtils.getNmericProperty(parent.baseStats, "STATS", "MAX_HP") \
	+ GUtils.getNmericProperty(parent.stats, "STATS", "MAX_HP") if get_parent() is Entity else maxHealth
	maxHealth = maxi(maxHealth, MIN_HP)
	currentHealth = maxHealth
#	if(healthBar):
#		healthBar.setHealth(currentHealth,maxHealth)

func damage(attack: AttackResource):
	var oldHealth : int
	
	oldHealth = currentHealth
	currentHealth = max(currentHealth - GUtils.getNmericProperty(attack.stats, "ATTACK", "DMG"), 0)
	healthChanged.emit(oldHealth, currentHealth)
	
	#TODO add 
	#TODO add DMG_OVER_TIME
	
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
	regenerate(passiveRegeneration)
	
func regenerate(hp : int):
	var oldHealth = currentHealth
	currentHealth = min(maxHealth, currentHealth + hp)
	healthChanged.emit(oldHealth, currentHealth)
	ShowStatistics.updatePlayerHealth(self)
#	updateHealthBar(healthBar, currentHealth)

#func updateHealthBar(_healthBar : HealthBar, _currentHealth : int):
#	if(_healthBar):
#		_healthBar.setHealth(_currentHealth,maxHealth)
