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
@onready var discardCell = %DiscardCell
@onready var lootCell = %LootCell

var columnCount

var gridArray = []
var dragData : ItemDragData = null
var currentSlot = null
var currentPreviewSlot = null
var canDropDrag = false
var iconAnchor : Vector2
var inventoryReady = false

var maximumItemsFromLootAvailable = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#dropPanel.get_local_mouse_position()
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
		inventoryItem.isLoot = false
		addItemToCell(placementLocation, inventoryItem)
	emit_signal("inventory_changed", getItems())

func getItems() -> Array[InventoryItemV2]:
	var items = [] as Array[InventoryItemV2]
	for row in inventoryGridContainer.get_children():
		for cell in row.get_children():
			if cell.get_child(1):
				items.append(cell.get_child(1))
	
	for item : InventoryItemV2 in items:
		var synergyResults = {}
		for synergy : Synergy in item.synergies:
			var affectedItems : Array[InventoryItemV2] = []
			for cell : InventoryCellV2 in synergy.getFields(item, self):
				if !affectedItems.has(cell.itemRef):
					affectedItems.append(cell.itemRef)
					var stats := synergy.getStats(item, cell.itemRef, self)
					item.synergyResults[cell.itemRef] = stats
					cell.itemRef.statsFromSynergies = GUtils.addToStats(cell.itemRef.statsFromSynergies, stats)
	return items

func showPrewiewInCell(cell : InventoryCellV2, dragData : ItemDragData):
	cell.add_child(dragData.cellPreview)
	dragData.cellPreview.position = dragData.gridOffset * CELL_SIZE_PX
	if !canDropDrag:
		dragData.cellPreview.set_modulate(Color(0.7,0.0,0.0,0.4))
	else:
		dragData.cellPreview.set_modulate(Color(1.0,1.0,1.0,0.4))

func addItemToCell(cell : InventoryCellV2, item : InventoryItemV2, ):
	if cell.isLoot:
		item.gridCell = cell
		cell.add_child(item)
		item.position = Vector2(0,0)
		if item.textureRect.size.x > 0 || item.textureRect.size.y >0:
			var scale = CELL_SIZE_PX/maxf(item.textureRect.size.x, item.textureRect.size.y)
			item.textureRect.scale *= scale
	else:
		item.textureRect.scale = Vector2(1,1)
		item.gridCell = cell
		cell.add_child(item)
		for pos in item.gridPositions:
			gridArray[cell.cellID + pos.x + pos.y * columnCount].itemRef = item
			gridArray[cell.cellID + pos.x + pos.y * columnCount].state = InventoryCellV2.States.TAKEN
			gridArray[cell.cellID + pos.x + pos.y * columnCount].updateColor()
			
		item.position = item.gridPositionOffset * CELL_SIZE_PX

func moveItemToCell(cell : InventoryCellV2, item : InventoryItemV2):
	var itemCell = item.gridCell
	#itemCell.remove_child(item)
	#TODO sprawdzic czy nie jest to juz wykonywane w updateStatusForDrag
	if itemCell.type == InventoryCellV2.Types.CELL:
		for pos in item.gridPositions:
			gridArray[itemCell.cellID + pos.x + pos.y * columnCount].itemRef = null
	addItemToCell(cell, item)

func moveItemToDiscard(at_position: Vector2, item : InventoryItemV2):
	var itemCell = item.gridCell
	if itemCell.type == InventoryCellV2.Types.CELL:
		for pos in item.gridPositions:
			gridArray[itemCell.cellID + pos.x + pos.y * columnCount].itemRef = null
	item.gridCell = discardCell
	discardCell.add_child(item)
	item.position = at_position

func moveItemToLoot(at_position: Vector2, item : InventoryItemV2):
	var itemCell = item.gridCell
	if itemCell.type == InventoryCellV2.Types.CELL:
		for pos in item.gridPositions:
			gridArray[itemCell.cellID + pos.x + pos.y * columnCount].itemRef = null
	item.gridCell = lootCell
	lootCell.add_child(item)
	item.position = at_position

func checkCellAvailability(aCell, data):
	if aCell.isLoot:
		return false if aCell.itemRef else true
	for gridPosition in data.grid:
		var cellToCheck = aCell.cellID + gridPosition[0] + gridPosition[1]*columnCount
		var lineSwithCheck = aCell.cellID % columnCount + gridPosition[0]
		#if exceeds left/right bounds
		if lineSwithCheck < 0 or lineSwithCheck >= columnCount:
			return false
		#if exceeds top/bottom bounds
		if cellToCheck < 0 or cellToCheck >= gridArray.size():
			return false
		#if cell taken
		if gridArray[cellToCheck].itemRef && gridArray[cellToCheck].itemRef != data.item:
			return false
	return true

func updateStatusForDrag(data : ItemDragData):
	dragData = data
	if data.item.gridCell.type == InventoryCellV2.Types.CELL:
		for gridPosition in data.item.gridPositions:
			var cell = data.source.cellID + gridPosition[0] + gridPosition[1]*columnCount
			gridArray[cell].itemRef = null
			gridArray[cell].state = InventoryCellV2.States.DEFAULT
			gridArray[cell].updateColor()
	data.item.get_parent().remove_child(data.item)

func restoreStatusFromDragData():
	if dragData.item.isLoot:
		lootCell.add_child(dragData.item)
		return
	if dragData.source.type == InventoryCellV2.Types.CELL:
		for gridPosition in dragData.item.gridPositions:
			var cell = dragData.source.cellID + gridPosition[0] + gridPosition[1]*columnCount
			gridArray[cell].itemRef = dragData.item
	# if discard moveItemToDiscard(v(0,0), dragdata.item)
	dragData.item.gridCell.add_child(dragData.item)

#TODO save rotation
func rotateItem():
	for i in dragData.grid.size():
		dragData.grid[i] = Vector2(-dragData.grid[i].y, dragData.grid[i].x)
	dragData.gridOffset = Vector2(-dragData.gridOffset.y, dragData.gridOffset.x)
	dragData.preview.rotation_degrees += 90
	dragData.cellPreview.rotation_degrees += 90
	if dragData.preview.rotation_degrees>=360:
		dragData.preview.rotation_degrees = 0
	if dragData.cellPreview.rotation_degrees>=360:
		dragData.cellPreview.rotation_degrees = 0
	
	removeCellPreview()
	showPrewiewInCell(currentPreviewSlot, dragData)

func removeCellPreview():
	if currentPreviewSlot:
		var preview = currentPreviewSlot.get_node("InventoryItemPreview")
		if preview:
			currentPreviewSlot.remove_child(preview)

func finishProcessingInventory():
	for row in inventoryGridContainer.get_children():
		for cell in row.get_children():
			if cell.itemRef:
				cell.itemRef.isLoot = false

func clearDiscard():
	for item in discardCell.get_children():
		if item is InventoryItemV2:
			item.queue_free()
			
func clearLoot():
	for item in lootCell.get_children():
		if item is InventoryItemV2:
			item.queue_free()

func _notification(what):
	if what == Node.NOTIFICATION_DRAG_END:
		if !get_viewport().gui_is_drag_successful():
			restoreStatusFromDragData()
		dragData = null
		removeCellPreview()
		currentPreviewSlot = null
		inventory_changed.emit(getItems())

func _on_cell_mouse_entered(aCell):
	currentSlot = aCell
	if dragData:
		removeCellPreview()
		currentPreviewSlot = aCell
		canDropDrag = checkCellAvailability(aCell, dragData)
		showPrewiewInCell(aCell, dragData)
	
func _on_cell_mouse_exited(aCell):
	pass

func _on_soul_loot_ready(items : Array[Item]):
	for item in items:
		var inventoryItem = inventoryItemScene.instantiate()
		inventoryItem.loadItem(item)
		inventoryItem.isLoot = true
		inventoryItem.gridCell = lootCell
		lootCell.add_child(inventoryItem)
		inventoryItem.position = VectorUtilsGlobal.getRandomPointInsideControl(soulLoot, inventoryItem.size.x, inventoryItem.size.y)

func _on_ready_button_pressed():
	finishProcessingInventory()
	clearDiscard()
	clearLoot()
	lootClosed.emit()
