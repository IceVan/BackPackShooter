extends Node2D
class_name InventoryItem

@export var itemResource : Item
@export var gridCell : InventoryCell
@export var previousGridCell : InventoryCell
@export var gridPositions : Array[Vector2] = []
@export var affectedBy : Array[InventoryItem] = []

@export var textureRect : TextureRect

var itemId : int
var selected : bool = false

	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	
func loadItem(aitemResource : Item):
	textureRect.texture = load(aitemResource.imgPath)
	itemResource = aitemResource
	gridPositions = aitemResource.gridPositions.duplicate(true)
	rotation_degrees = aitemResource.rotationDegrees

#TODO save rotation
func rotateItem():
	for i in gridPositions.size():
		gridPositions[i] = Vector2(-gridPositions[i].y, gridPositions[i].x)
	rotation_degrees += 90
	if rotation_degrees>=360:
		rotation_degrees = 0

func snapToCell(cell : InventoryCell, gridSize : Vector2i):
	var _position = Vector2(cell.cellID % gridSize.x, cell.cellID / gridSize.x) * cell.size if cell.cellID else cell.position
	#cell.get_rect().position
	if int(rotation_degrees) % 180 == 0 :
		_position += textureRect.size/2
	else:
		var tempXYSwitch = Vector2(textureRect.size.y, textureRect.size.x)
		_position += tempXYSwitch/2
		
	position = _position
	
	selected = false
