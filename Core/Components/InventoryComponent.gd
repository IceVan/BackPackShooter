extends Node
class_name InventoryComponent

#TODO to change where INV is and how to access it
@export var inventoryUI : InventoryV2
@export var items : Array[Item] = []

func _init():
	pass

func getStatsFromItems() -> Dictionary :
	var stats = {}
	for item in items:
		GUtils.addToStats(stats, item.stats)
	
	return stats

func addItems(addedItems : Array = []):
	items.append_array(addedItems)
	get_parent().updateStats()

func _on_inventoryUI_inventory_changed(items):
	get_parent().updateStats()
