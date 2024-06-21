extends InventoryComponent
class_name PlayerInventoryComponent

@export var inventoryGrid : Array[Array] = [[]] 

@export var size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(size, "Inventory should have size set.")
	initializeTable()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func createRow(x : int) -> Array[InventoryCell]:
	var row = []
	for i in size.y:
		row.append(InventoryCell.new(Vector2(x,i), null))
	return row

func initializeTable() -> Array[Array]:
	var grid = []
	for i in size.x:
		grid.append(createRow(i))
	return grid

func rotateItem(item : InventoryItem):
	var positions = []
	for v in item.gridPositions:
		positions.append(Vector2(v.y, -v.x))
	item.gridPositions = positions
