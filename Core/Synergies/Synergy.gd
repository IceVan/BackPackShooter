extends Node
class_name Synergy

@export var label := ""
@export var params := {}

func getFields(item : InventoryItemV2, inventoryNode : InventoryV2) -> Array[InventoryCellV2]:
	return []

func getStats(item1 : InventoryItemV2, item2 : InventoryItemV2, inventoryNode : InventoryV2) -> Dictionary:
	return {}
