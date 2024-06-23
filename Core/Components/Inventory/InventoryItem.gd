extends Node2D
class_name InventoryItem

@export var itemResource : Item
@export var gridCell : InventoryCell
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
	gridPositions = aitemResource.gridPositions
	rotation_degrees = aitemResource.rotationDegrees

#TODO save rotation
func rotateItem():
	for i in gridPositions.size():
		gridPositions[i] = Vector2(-gridPositions[i].y, gridPositions[i].x)
	rotation_degrees += 90
	if rotation_degrees>=360:
		rotation_degrees = 0

func snapTo(destination : Vector2):
	var tween = get_tree().create_tween()
	
	#NO IDEA WHAT IS HAPPENING
	#fixes snapping of image to wrong position
	if int(rotation_degrees) % 180 == 0 :
		destination += textureRect.size/2
	else:
		var tempXYSwitch = Vector2(textureRect.size.y, textureRect.size.x)
		destination += tempXYSwitch/2
		
	tween.tween_property(self, "global_position", destination, 0.15).set_trans(Tween.TRANS_SINE)
	selected = false
