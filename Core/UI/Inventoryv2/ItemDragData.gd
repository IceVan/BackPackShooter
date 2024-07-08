class_name ItemDragData

signal dragCompleted(data:ItemDragData)

var source: Control = null
var destination: Control = null

var item: InventoryItemV2
var grid : Array
var gridOffset : Vector2
var preview: Control

func _init(_source: Control, _item: InventoryItemV2):
	var previewScene = load("res://Core/UI/Inventoryv2/InventoryDragPreviewV2.tscn")
	
	self.source = _source
	self.item = _item
	self.grid = _item.gridPositions.duplicate()
	self.gridOffset = Vector2(_item.gridPositionOffset)
	self.preview = previewScene.instantiate()
	self.preview.get_node("Texture").texture = _item.textureRect.texture.duplicate()
	self.preview.pivot_offset = Vector2(32, 32)
	self.preview.rotation_degrees = _item.rotation_degrees
	self.preview.tree_exiting.connect(_on_tree_exiting)

func _on_tree_exiting()->void:
	dragCompleted.emit(self)
