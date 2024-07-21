extends Control
class_name InventoryItemV2

@export var itemResource : Item
@export var gridCell : InventoryCellV2
@export var previousGridCell : InventoryCellV2
@export var gridPositions : Array[Vector2] = []
var synergies : Array[Synergy] = []
var synergyResults : Dictionary = {}
var statsFromSynergies : Dictionary = {}

@export var textureRect : TextureRect

var gridPositionOffset
var itemId : int
var selected : bool = false
var isLoot = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	
func loadItem(aitemResource : Item):
	textureRect.texture = load(aitemResource.imgPath)
	itemResource = aitemResource
	gridPositions = aitemResource.gridPositions.duplicate(true)
	gridPositionOffset = Vector2(0,0)
	for pos in gridPositions:
		#save offset (leftmost corner of item outline rect)
		if pos.x < gridPositionOffset.x : gridPositionOffset.x = pos.x
		if pos.y < gridPositionOffset.y : gridPositionOffset.y = pos.y
	rotation_degrees = aitemResource.rotationDegrees


func snapToCell(cell : InventoryCellV2, gridSize : Vector2i):
	var _position = Vector2(cell.cellID % gridSize.x, cell.cellID / gridSize.x) * cell.size if cell.cellID else cell.position
	#cell.get_rect().position
	if int(rotation_degrees) % 180 == 0 :
		_position += textureRect.size/2
	else:
		var tempXYSwitch = Vector2(textureRect.size.y, textureRect.size.x)
		_position += tempXYSwitch/2
		
	position = _position
	
	selected = false

func _get_drag_data(at_position):
	var item = self
	if item == null: return null

	var dragData = ItemDragData.new(gridCell, item)
	set_drag_preview(dragData.preview)
	gridCell.inventoryNode.updateStatusForDrag(dragData)
	return dragData

#force_drag(data, preview)
#func _can_drop_data(at_position, data):
	#var t = gridCell.inventoryNode.checkCellAvailability(gridCell.inventoryNode.currentSlot, data)
	#print_debug(t)
	#return t
	#
	##match type:
		##Types.CELL:
			##return inventoryNode.checkCellAvailability(self, data)
		##Types.DISCARD:
			##return true
		##Types.LOOT:
			##return false
#
#func _drop_data(at_position, data):
	#data.item.gridPositions = data.grid
	#data.item.rotation_degrees = data.preview.rotation_degrees
	#data.item.gridPositionOffset = data.gridOffset
	#gridCell.inventoryNode.moveItemToCell(gridCell.inventoryNode.currentSlot, data.item)
	#data.preview = null
