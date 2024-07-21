class_name ItemDragData

signal dragCompleted(data:ItemDragData)

var source: Control = null
var destination: Control = null

var item: InventoryItemV2
var grid : Array
var gridOffset : Vector2
var preview: Control
var cellPreview : Control

func _init(_source: Control, _item: InventoryItemV2):
	var previewScene = load("res://Core/UI/Inventoryv2/InventoryDragPreviewV2.tscn")
	var inventoryItemPreviewScene = load("res://Core/UI/Inventoryv2/InventoryItemPreviewV2.tscn")
	
	self.source = _source
	self.item = _item
	self.grid = _item.gridPositions.duplicate()
	self.gridOffset = Vector2(_item.gridPositionOffset)
	self.preview = previewScene.instantiate()
	self.preview.get_node("Texture").texture = _item.textureRect.texture.duplicate()
	self.preview.pivot_offset = Vector2(32, 32)
	self.preview.rotation_degrees = _item.rotation_degrees
	self.preview.tree_exiting.connect(_on_tree_exiting)
	
	self.cellPreview =  inventoryItemPreviewScene.instantiate()
	self.cellPreview.get_node("Texture").texture = _item.textureRect.texture.duplicate()
	self.cellPreview.pivot_offset = Vector2(32, 32)
	self.cellPreview.rotation_degrees = _item.rotation_degrees

func _on_tree_exiting()->void:
	dragCompleted.emit(self)
