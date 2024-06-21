extends Control
class_name Inventory

@export var gridSize : Vector2i

@onready var cellScene = preload("res://Core/Components/Inventory/InventoryCell.tscn")
@onready var gridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer

var gridArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	gridSize = Vector2i(16,8)
	assert(gridSize)
	gridContainer.columns = gridSize.x
	for i in range(gridSize.x * gridSize.y):
		createCell()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func createCell():
	var nCell = cellScene.instantiate()
	nCell.cellID = gridArray.size()
	nCell.gridLocation = Vector2(floori(nCell.cellID/gridSize.x), nCell.cellID % gridSize.x)
	gridContainer.add_child(nCell)
	gridArray.append(nCell)
	nCell.cellEntered.connect(_on_cell_mouse_entered)
	nCell.cellExited.connect(_on_cell_mouse_exited)
	
func _on_cell_mouse_entered(aCell):
	aCell.setColor(aCell.States.TAKEN)
	
func _on_cell_mouse_exited(aCell):
	aCell.setColor(aCell.States.DEFAULT)
