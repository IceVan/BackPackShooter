extends Node
class_name InventoryComponent

#TODO to change where INV is and how to access it
@export var inventoryUI : InventoryV2
@export var items : Array[Item] = []

var inventoryStats : Dictionary = {}

func getStats():
	if inventoryStats.is_empty() && !inventoryUI:
		inventoryStats = getStatsFromItems()
	return inventoryStats

func getStatsFromItems() -> Dictionary :
	var stats = {}
	for item in items:
		GUtils.addToStats(stats, item.stats)
	
	return stats

func addItems(addedItems : Array = []):
	items.append_array(addedItems)
	inventoryStats = getStatsFromItems()
	get_parent().updateStats()

func _on_inventoryUI_inventory_changed(items: Array[InventoryItemV2]):
	inventoryStats.clear()
	for i : InventoryItemV2 in items:
		var s : Dictionary = {}
		s = GUtils.addToStats(s, i.itemResource.stats)
		s = GUtils.addToStats(s, i.statsFromSynergies)
		inventoryStats = GUtils.addToStats(inventoryStats, s)
	#TODO get parent change to something other
	(get_parent() as Entity).updateStats()
