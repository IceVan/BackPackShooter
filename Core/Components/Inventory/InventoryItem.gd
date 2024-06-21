extends Node2D
class_name InventoryItem

@export var itemResource : Item
@export var gridCell : InventoryCell
@export var gridPositions : Array[Vector2] = []

@onready var textureRect = $TextureRect

var itemId : int
var selected : bool = false

func _init(item : Item):
	itemResource = item
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func loadItem():
	pass
