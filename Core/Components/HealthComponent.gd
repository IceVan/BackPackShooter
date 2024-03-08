extends Node2D
class_name HealthComponent

const MIN_HP = 1
#@export var healthBar: HealthBar

@export var maxHealth = MIN_HP
@export var regenerationPerSec = 1

@onready var parent = get_parent()

signal healthChanged(old_health, new_health)
signal died

var currentHealth 

func _ready():
	maxHealth = parent.baseHealth + parent.stats.get(Enums.Tags.MAX_HP,0) if get_parent() is Entity else maxHealth
	currentHealth = maxHealth
#	if(healthBar):
#		healthBar.setHealth(currentHealth,maxHealth)

func damage(attack: AttackResource):
	var oldHealth : int
	for dmg in attack.stats["DMG"].keys():
		oldHealth = currentHealth
		currentHealth = max(currentHealth - attack.stats["DMG"][dmg], 0)
		healthChanged.emit(oldHealth, currentHealth)
		if !get_parent().isPlayer() and !attack.enemy:
			ShowStatistics.addDamageDealt(dmg, oldHealth-currentHealth)
	if(currentHealth <= 0 && get_parent().has_method("destroy")):
		died.emit()
			
func isAlive() -> bool:
	return currentHealth > 0

func fullyRegenerate():
	var oldHealth = currentHealth
	currentHealth = maxHealth
	healthChanged.emit(oldHealth, currentHealth)
#	updateHealthBar(healthBar, currentHealth)
	
func regenerate():
	var oldHealth = currentHealth
	currentHealth = min(maxHealth, currentHealth + regenerationPerSec)
	healthChanged.emit(oldHealth, currentHealth)
#	updateHealthBar(healthBar, currentHealth)

func _on_regeneration_timeout():
	print("regeneration timer")
	regenerate()

#func updateHealthBar(_healthBar : HealthBar, _currentHealth : int):
#	if(_healthBar):
#		_healthBar.setHealth(_currentHealth,maxHealth)
