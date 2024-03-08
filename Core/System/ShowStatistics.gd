extends Node

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
	
