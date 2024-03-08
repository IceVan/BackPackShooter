extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateDamageStatistics()

func updateDamageStatistics():
	$TotalDamageDealt.text = "Total dmg dealt: " + str(ShowStatistics.getTotDamageStats())
	$EnemiesKilled.text = "EnemiesKilled: " + str(ShowStatistics.getEnemiesKilled())
	var demageByType = """Damage by type:
		"""
	var damageTypes = ShowStatistics.getDamageByTypeStats()
	var damageTranslation = EnumsTranslation.tagsTranslated
	for dmg in damageTypes:
		demageByType = demageByType + damageTranslation[dmg] + ": " + str(damageTypes[dmg]) + """
		"""
	$DemageByTypeDealt.text = demageByType
