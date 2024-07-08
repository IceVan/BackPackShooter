extends Control
class_name InventoryV2

const CELL_SIZE_PX = 64

signal inventory_changed(currentItems)
signal lootClosed

@export var gridSize : Vector2i
@export var entity : Entity

@onready var inventoryItemScene = preload("res://Core/UI/Inventoryv2/InventoryItemV2.tscn")
@onready var cellScene = preload("res://Core/UI/Inventoryv2/InventoryCellV2.tscn")
@onready var gridRowScene = preload("res://Core/UI/Inventoryv2/InventoryGridRowV2.tscn")
@onready var inventoryGridContainer = %InventoryGridContainer
@onready var gridOuterContainer = %GridOuterContainer
@onready var statPanel = %StatsPanel
@onready var soulTexture = %SoulTexture
@onready var soulDropContainer = %SoulDropContainer
@onready var soulLoot = %SoulLoot

var columnCount

var gridArray = []
var dragData : ItemDragData = null
var currentSlot = null
var iconAnchor : Vector2
var inventoryReady = false

var maximumItemsFromLootAvailable = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	soulDropContainer.visible = false
	assert(gridSize)
	columnCount = gridSize.x
	for i in range(gridSize.y):
		var row = createRow()
		for y in range(gridSize.x):
			createCell(row)
	
	for cell in soulLoot.get_children():
		cell.cellEntered.connect(_on_cell_mouse_entered)
		cell.cellExited.connect(_on_cell_mouse_exited)
	
	get_tree().current_scene.playerChanged.connect(initializePlayerInventory)

func _process(delta):
	if entity && dragData:
		if Input.is_action_just_pressed("ACTION_2"):
			rotateItem()


func createCell(row : HBoxContainer):
	var nCell = cellScene.instantiate()
	nCell.cellID = gridArray.size()
	row.add_child(nCell)
	gridArray.append(nCell)
	nCell.inventoryNode = self
	nCell.cellEntered.connect(_on_cell_mouse_entered)
	nCell.cellExited.connect(_on_cell_mouse_exited)

func createRow():
	var row = gridRowScene.instantiate()
	inventoryGridContainer.add_child(row)
	return row

func initializePlayerInventory(aentity : Entity):
	#clearInventory()
	if aentity.isPlayer() && aentity.inventoryComponent:
		entity = aentity
		inventory_changed.connect(entity.inventoryComponent._on_inventoryUI_inventory_changed)
		#pushing initialization to next callStack which (i think) is after cellNodes are ready and have position
		#await ready
		initializeItems.call_deferred(entity.inventoryComponent.items)

func initializeItems(items : Array[Item]):
	
	for item in items:
		var inventoryItem = inventoryItemScene.instantiate()
		var placementLocation = gridArray[item.gridLocation.x + item.gridLocation.y*columnCount]
		inventoryItem.loadItem(item)
		addItemToCell(placementLocation, inventoryItem)
	#emit_signal("inventory_changed", getItems())

func addItemToCell(cell : InventoryCellV2, item : InventoryItemV2, ):
	item.gridCell = cell
	cell.add_child(item)
	for pos in item.gridPositions:
		gridArray[cell.cellID + pos.x + pos.y * columnCount].itemRef = item
		gridArray[cell.cellID + pos.x + pos.y * columnCount].state = InventoryCell.States.TAKEN
		gridArray[cell.cellID + pos.x + pos.y * columnCount].updateColor()
		
	
	print_debug("Grid offset: ", item.gridPositionOffset, " Position Offset: ", item.gridPositionOffset * CELL_SIZE_PX, " Position: ", item.position)
	item.position = item.gridPositionOffset * CELL_SIZE_PX

func moveItemToCell(cell : InventoryCellV2, item : InventoryItemV2):
	var itemCell = item.gridCell
	#itemCell.remove_child(item)
	for pos in item.gridPositions:
		gridArray[itemCell.cellID + pos.x + pos.y * columnCount].itemRef = null
	addItemToCell(cell, item)

func checkCellAvailability(aCell, data):
	var canPlace = true
	if aCell.isLoot:
		return false if aCell.itemRef else true
	for gridPosition in data.grid:
		var cellToCheck = aCell.cellID + gridPosition[0] + gridPosition[1]*columnCount
		var lineSwithCheck = aCell.cellID % columnCount + gridPosition[0]
		#if exceeds left/right bounds
		if lineSwithCheck < 0 or lineSwithCheck >= columnCount:
			canPlace = false
		#if exceeds top/bottom bounds
		if cellToCheck < 0 or cellToCheck >= gridArray.size():
			canPlace = false
		#if cell taken
		if gridArray[cellToCheck].itemRef:
			canPlace = false
	return canPlace

func updateStatusForDrag(data : ItemDragData):
	dragData = data
	for gridPosition in data.item.gridPositions:
		var cell = data.source.cellID + gridPosition[0] + gridPosition[1]*columnCount
		gridArray[cell].itemRef = null
		gridArray[cell].state = InventoryCell.States.DEFAULT
		gridArray[cell].updateColor()
	data.item.get_parent().remove_child(data.item)

func restoreStatusFromDragData():
	for gridPosition in dragData.item.gridPositions:
		var cell = dragData.source.cellID + gridPosition[0] + gridPosition[1]*columnCount
		gridArray[cell].itemRef = dragData.item
	dragData.item.gridCell.add_child(dragData.item)

#TODO save rotation
func rotateItem():
	for i in dragData.grid.size():
		dragData.grid[i] = Vector2(-dragData.grid[i].y, dragData.grid[i].x)
	dragData.gridOffset = Vector2(-dragData.gridOffset.y, dragData.gridOffset.x)
	dragData.preview.rotation_degrees += 90
	if dragData.preview.rotation_degrees>=360:
		dragData.preview.rotation_degrees = 0


func _notification(what):
	if what == Node.NOTIFICATION_DRAG_END:
		if !get_viewport().gui_is_drag_successful():
			restoreStatusFromDragData()
			dragData = null

func _on_cell_mouse_entered(aCell):
	currentSlot = aCell
	#if itemHeld:
		#checkCellAvailability(aCell)
		#updateGridColors(aCell)
		
func _on_cell_mouse_exited(aCell):
	pass
	#clearGrid()

func _on_soul_loot_ready():
	pass
