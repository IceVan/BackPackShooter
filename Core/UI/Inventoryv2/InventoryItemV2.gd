extends Control
class_name InventoryItemV2

@export var itemResource : Item
@export var gridCell : InventoryCellV2
@export var previousGridCell : InventoryCellV2
@export var gridPositions : Array[Vector2] = []
@export var affectedBy : Array[InventoryItemV2] = []

@export var textureRect : TextureRect

var gridPositionOffset
var itemId : int
var selected : bool = false


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

#TODO save rotation
func rotateItem():
	for i in gridPositions.size():
		gridPositions[i] = Vector2(-gridPositions[i].y, gridPositions[i].x)
	gridPositionOffset = Vector2(-gridPositionOffset.y, gridPositionOffset.x)
	rotation_degrees += 90
	if rotation_degrees>=360:
		rotation_degrees = 0

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
