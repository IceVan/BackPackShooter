extends Node
class_name InventoryComponent

@export var items : Array[Item] = []

func getStatsFromItems() -> Dictionary :
	var stats = {}
	for item in items:
		GUtils.addToStats(stats, item.stats)
	
	return stats
