extends Node

#temporary
var health : Dictionary = {}
var playerHealth : Dictionary = {}
var player

var enemiesKilled : int = 0
var allDamageDealt : int = 0

var damageDealtByType : Dictionary = {}

func addDamageDealt(attackType, damage):
	if damageDealtByType.has(attackType):
		damageDealtByType[attackType] += damage
	else:
		damageDealtByType[attackType] = damage
	allDamageDealt += damage

func enemyKilled():
	enemiesKilled += 1

func getTotDamageStats():
	return allDamageDealt

func getDamageByTypeStats():
	return damageDealtByType

func getEnemiesKilled():
	return enemiesKilled

func getHealth():
	return "{%s}: {%d}/{%d}" % health.values() if health.values().size() == 3 else ""

func updatePlayerHealth(healthComponent : HealthComponent):
	if(!player):
		player = get_tree().get_first_node_in_group("Player")
	
	health = {
		"NAME" : healthComponent.get_parent().name,
		"HP" : healthComponent.currentHealth,
		"MAX_HP" : healthComponent.maxHealth
	}
	playerHealth = {
		"NAME" : player.healthComponent.get_parent().name,
		"HP" : player.healthComponent.currentHealth,
		"MAX_HP" : player.healthComponent.maxHealth
	}

func getLastTargetHealth():
	return "{%s}: {%d}/{%d}" % playerHealth.values() if health.values().size() == 3 else ""

