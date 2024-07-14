extends TextureRect
class_name InventoryCellV2

@export var itemRef : InventoryItemV2
@export var isLoot : bool = false


@onready var filter = $StatusFilter

@export var inventoryNode : InventoryV2 = null

var cellID
var isHovering : bool = false
var state = States.DEFAULT
@export var type : Types = Types.CELL
enum States {DEFAULT, INACTIVE, TAKEN, FREE}
enum Types {CELL, DISCARD, LOOT}

signal cellEntered(cell)
signal cellExited(cell)

func isMainItemCell(item : InventoryItemV2):
	if self == item.gridCell:
		return true
	return  false

func setColor(aState = States.DEFAULT) -> void:
	if type == Types.CELL:
		match aState:
			States.DEFAULT:
				filter.color = Color(Color.WHITE, 0.5)
			States.TAKEN:
				filter.color = Color(Color.RED, 0.2)
			States.FREE:
				filter.color = Color(Color.GREEN, 0.2)

func updateColor() -> void:
	setColor(state)

func _process(delta):
	if get_global_rect().has_point(get_global_mouse_position()):
		if not isHovering:
			isHovering = true
			emit_signal("cellEntered", self)
	else:
		if isHovering:
			isHovering = false
			emit_signal("cellExited",self)

func _can_drop_data(at_position, data):
	match type:
		Types.CELL:
			return inventoryNode.checkCellAvailability(self, data)
		Types.DISCARD:
			return true
		Types.LOOT:
			return data.item.isLoot

func _drop_data(at_position, data):
	data.item.gridPositions = data.grid
	data.item.rotation_degrees = data.preview.rotation_degrees
	data.item.gridPositionOffset = data.gridOffset
	data.preview = null
	match type:
		Types.CELL:
			inventoryNode.moveItemToCell(self, data.item)
		Types.DISCARD:
			inventoryNode.moveItemToDiscard(at_position, data.item)
		Types.LOOT:
			inventoryNode.moveItemToLoot(at_position, data.item)

#func dropAtCell(data):
	#data.item.gridPositions = data.grid
	#data.item.rotation_degrees = data.preview.rotation_degrees
	#data.item.gridPositionOffset = data.gridOffset
	#inventoryNode.moveItemToCell(self, data.item)
	#data.preview = null
#
#func dropAtDiscard(at_position, data):
	#data.item.gridPositions = data.grid
	#data.item.rotation_degrees = data.preview.rotation_degrees
	#data.item.gridPositionOffset = data.gridOffset
	#inventoryNode.moveItemToDiscard(self, data.item)
	#data.preview = null
#
#func dropAtLoot(at_position, data):
	#data.item.gridPositions = data.grid
	#data.item.rotation_degrees = data.preview.rotation_degrees
	#data.item.gridPositionOffset = data.gridOffset
	#inventoryNode.moveItemToDiscard(self, data.item)
	#data.preview = null
