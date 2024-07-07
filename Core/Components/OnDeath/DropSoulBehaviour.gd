extends OnDeathBehaviour

func process(entity : Entity):
	if entity && get_tree().current_scene is GameManager:
		var soulValue = GUtils.getNmericProperty(entity.stats, "STATS", "SOULS", 1)
		get_tree().current_scene.locationManager.spawnSoul(entity.global_position, soulValue)
