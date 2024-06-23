extends Control
class_name Inventory

signal inventory_changed(currentItems)

@export var gridSize : Vector2i
@export var entity : Entity

@onready var inventoryItemScene = preload("res://Core/Components/Inventory/InventoryItem.tscn")
@onready var cellScene = preload("res://Core/Components/Inventory/InventoryCell.tscn")
@onready var gridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var scrollContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
var columnCount

var gridArray = []
var itemHeld = null
var currentSlot = null
var canPlace = false
var iconAnchor : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	gridSize = Vector2i(12,7)
	assert(gridSize)
	gridContainer.columns = gridSize.x
	columnCount = gridContainer.columns
	for i in range(gridSize.x * gridSize.y):
		createCell()
	
	if entity.isPlayer() && entity.inventoryComponent:
		inventory_changed.connect(entity.inventoryComponent._on_inventoryUI_inventory_changed)
		#pushing initialization to next callStack which (i think) is after cellNodes are ready and have position
		initializeItems.call_deferred(entity.inventoryComponent.items)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if itemHeld:
		if Input.is_action_just_pressed("ACTION_2"):
			rotateItem()
		elif Input.is_action_just_pressed("ACTION_1") \
		&& scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
			placeItem()
	else:
		if Input.is_action_just_pressed("ACTION_1") \
		&& scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
			pickItem()

func createCell():
	var nCell = cellScene.instantiate()
	nCell.cellID = gridArray.size()
	gridContainer.add_child(nCell)
	gridArray.append(nCell)
	nCell.cellEntered.connect(_on_cell_mouse_entered)
	nCell.cellExited.connect(_on_cell_mouse_exited)

func getItems() -> Array[InventoryItem]:
	var items : Array[InventoryItem] = []
	for cell in gridArray:
		if cell.itemRef:
			var uniqueId = true
			for item in items:
				if cell.itemRef.itemId == item.itemId:
					uniqueId = false
			if uniqueId:
				items.append(cell.itemRef)
	return items

#TODO
func updateSynergies() -> void:
	pass

func initializeItems(items : Array[Item]):
	
	for item in items:
		var inventoryItem = inventoryItemScene.instantiate()
		var placementLocation = gridArray[item.gridLocation.x + item.gridLocation.y*columnCount]
		inventoryItem.loadItem(item)
		inventoryItem.itemId = inventoryItem.get_instance_id()
		gridContainer.add_child(inventoryItem)
		inventoryItem.gridCell = placementLocation
		for gridPosition in item.gridPositions:
			var cell = gridArray[inventoryItem.gridCell.cellID + gridPosition.x + gridPosition.y*columnCount]
			cell.itemRef = inventoryItem
			#potrzebne
			if gridPosition.y < iconAnchor.y: iconAnchor.y = gridPosition.y
			if gridPosition.x < iconAnchor.x: iconAnchor.x = gridPosition.x
			
		var calculatedSnapDestination = placementLocation.cellID + iconAnchor.x + iconAnchor.y * columnCount
		iconAnchor = Vector2(2000,2000)
		
		inventoryItem.snapTo(gridArray[calculatedSnapDestination].global_position)
	emit_signal("inventory_changed", getItems())


func pickItem(): 
	if not currentSlot or not currentSlot.itemRef:
		return
		
	itemHeld = currentSlot.itemRef
	itemHeld.selected = true
	
	itemHeld.get_parent().remove_child(itemHeld)
	add_child(itemHeld)
	itemHeld.global_position = get_global_mouse_position()
	
	for gridPosition in itemHeld.gridPositions:
		var gridPositionToCheck = itemHeld.gridCell.cellID + gridPosition[0] + gridPosition[1] * columnCount
		gridArray[gridPositionToCheck].state = InventoryCell.States.FREE
		gridArray[gridPositionToCheck].itemRef = null
	
	checkCellAvailability(currentSlot)
	updateGridColors(currentSlot)

func placeItem():
	if not canPlace or not currentSlot:
		return
	
	var calculateCellId = currentSlot.cellID + iconAnchor.x + iconAnchor.y * columnCount 
	itemHeld.snapTo(gridArray[calculateCellId].global_position)
	
	itemHeld.get_parent().remove_child(itemHeld)
	gridContainer.add_child(itemHeld)
	itemHeld.global_position = get_global_mouse_position()
	
	itemHeld.gridCell = currentSlot
	for gridPosition in itemHeld.gridPositions:
		var gridPositionToCheck = currentSlot.cellID + gridPosition[0] + gridPosition[1] * columnCount
		gridArray[gridPositionToCheck].state = InventoryCell.States.TAKEN
		gridArray[gridPositionToCheck].itemRef = itemHeld
	
	itemHeld = null
	clearGrid()
	
	#after item placed
	updateSynergies()
	emit_signal("inventory_changed", getItems())
	
func checkCellAvailability(aCell):
	for gridPosition in itemHeld.gridPositions:
		var cellToCheck = aCell.cellID + gridPosition[0] + gridPosition[1]*columnCount
		var lineSwithCheck = aCell.cellID % columnCount + gridPosition[0]
		#if exceeds left/right bounds
		if lineSwithCheck < 0 or lineSwithCheck >= columnCount:
			canPlace = false
			return
		#if exceeds top/bottom bounds
		if cellToCheck < 0 or cellToCheck >= gridArray.size():
			canPlace = false
			return
		#if cell taken
		if gridArray[cellToCheck].state == InventoryCell.States.TAKEN:
			canPlace = false
			return
	canPlace = true


func updateGridColors(aCell):
	for gridPosition in itemHeld.gridPositions:
		var cellToCheck = aCell.cellID + gridPosition[0] + gridPosition[1]*columnCount
		var lineSwithCheck = aCell.cellID % columnCount + gridPosition[0]
		#if exceeds left/right bounds
		if lineSwithCheck < 0 or lineSwithCheck >= columnCount:
			continue
		#if exceeds top/bottom bounds
		if cellToCheck < 0 or cellToCheck >= gridArray.size():
			continue
		
		if canPlace:
			gridArray[cellToCheck].setColor(InventoryCell.States.FREE)
			
			#getting top left corner of image
			if gridPosition[1] < iconAnchor.y: iconAnchor.y = gridPosition[1]
			if gridPosition[0] < iconAnchor.x: iconAnchor.x = gridPosition[0]
		else:
			gridArray[cellToCheck].setColor(InventoryCell.States.TAKEN)

func clearGrid():
	for cell in gridArray:
		cell.setColor(InventoryCell.States.DEFAULT)

func rotateItem():
	itemHeld.rotateItem()
	clearGrid()
	if currentSlot:
		_on_cell_mouse_entered(currentSlot)

func _on_cell_mouse_entered(aCell):
	iconAnchor = Vector2(2000,2000)
	currentSlot = aCell
	if itemHeld:
		checkCellAvailability(aCell)
		updateGridColors(aCell)
		
func _on_cell_mouse_exited(aCell):
	clearGrid()
