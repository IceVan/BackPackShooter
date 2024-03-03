extends Node2D
class_name HealthComponent

const MIN_HP = 1
#@export var healthBar: HealthBar

@export var maxHealth = MIN_HP
@export var regenerationPerSec = 1

@onready var parent = get_parent()
var currentHealth 

func _ready():
	maxHealth = parent.baseHealth + parent.stats.get(Enums.Tags.MAX_HP,0) if get_parent() is Entity else maxHealth
	currentHealth = maxHealth
#	if(healthBar):
#		healthBar.setHealth(currentHealth,maxHealth)

func damage(attack: AttackResource):
	for dmg in attack.stats["DMG"].keys():
		currentHealth = max(currentHealth - attack.stats["DMG"][dmg], 0)
		
	print("Current HP ", currentHealth)
	if(currentHealth <= 0 && get_parent().has_method("destroy")):
		get_parent().destroy()
			
func isAlive() -> bool:
	return currentHealth > 0

func fullyRegenerate():
	currentHealth = maxHealth
#	updateHealthBar(healthBar, currentHealth)
	
func regenerate():
	currentHealth = min(maxHealth, currentHealth + regenerationPerSec)
#	updateHealthBar(healthBar, currentHealth)

func _on_regeneration_timeout():
	print("regeneration timer")
	regenerate()

#func updateHealthBar(_healthBar : HealthBar, _currentHealth : int):
#	if(_healthBar):
#		_healthBar.setHealth(_currentHealth,maxHealth)
