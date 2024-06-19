extends Node
class_name InventoryComponent

@export var items : Array[Item] = []

func getStatsFromItems() -> Dictionary :
	var stats = {}
	for item in items:
		GUtils.addToStats(stats, item.stats)
	
	return stats

func addItems(addedItems : Array = []):
	items.append_array(addedItems)
	get_parent().updateStats()
