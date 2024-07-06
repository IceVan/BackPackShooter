extends Control
class_name Inventory

signal inventory_changed(currentItems)
signal lootClosed

@export var gridSize : Vector2i
@export var entity : Entity

@onready var inventoryItemScene = preload("res://Core/UI/Inventory/InventoryItem.tscn")
@onready var cellScene = preload("res://Core/UI/Inventory/InventoryCell.tscn")
@onready var gridRowScene = preload("res://Core/UI/Inventory/InventoryGridRow.tscn")
@onready var inventoryGridContainer = %InventoryGridContainer
@onready var gridOuterContainer = %GridOuterContainer
@onready var statPanel = %StatsPanel
@onready var soulTexture = %SoulTexture
@onready var soulDropContainer = %SoulDropContainer
@onready var soulLoot = %SoulLoot

var columnCount

var gridArray = []
var itemHeld = null
var currentSlot = null
var canPlace = false
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entity:
		if itemHeld:
			if Input.is_action_just_pressed("ACTION_2"):
				rotateItem()
			elif Input.is_action_just_pressed("ACTION_1") \
			&& (gridOuterContainer.get_global_rect().has_point(get_global_mouse_position())
			|| soulLoot.get_global_rect().has_point(get_global_mouse_position())):
				placeItem()
			elif Input.is_action_just_pressed("ACTION_1"):
				returnItem()
		else:
			if Input.is_action_just_pressed("ACTION_1") \
			&& (gridOuterContainer.get_global_rect().has_point(get_global_mouse_position()) 
			|| soulLoot.get_global_rect().has_point(get_global_mouse_position())):
				pickItem()

func createCell(row : HBoxContainer):
	var nCell = cellScene.instantiate()
	nCell.cellID = gridArray.size()
	row.add_child(nCell)
	gridArray.append(nCell)
	nCell.cellEntered.connect(_on_cell_mouse_entered)
	nCell.cellExited.connect(_on_cell_mouse_exited)

func createRow():
	var row = gridRowScene.instantiate()
	inventoryGridContainer.add_child(row)
	return row

func clearLoot():
	for cell in soulLoot.get_children():
		if cell.itemRef:
			cell.itemRef.queue_free()
			cell.itemRef = null
			cell.state = InventoryCell.States.DEFAULT

func clearInventory():
	for item in getItems():
		item.queue_free()
	for cell in gridArray:
		cell.itemRef = null
		cell.state = InventoryCell.States.DEFAULT

func initializePlayerInventory(aentity : Entity):
	clearInventory()
	if aentity.isPlayer() && aentity.inventoryComponent:
		entity = aentity
		inventory_changed.connect(entity.inventoryComponent._on_inventoryUI_inventory_changed)
		#pushing initialization to next callStack which (i think) is after cellNodes are ready and have position
		#await ready
		initializeItems.call_deferred(entity.inventoryComponent.items)

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
		inventoryGridContainer.add_child(inventoryItem)
		inventoryItem.previousGridCell = placementLocation
		inventoryItem.gridCell = placementLocation
		for gridPosition in item.gridPositions:
			var cell = gridArray[inventoryItem.gridCell.cellID + gridPosition.x + gridPosition.y*columnCount]
			cell.itemRef = inventoryItem
			cell.state = InventoryCell.States.TAKEN
			
			#potrzebne
			if gridPosition.y < iconAnchor.y: iconAnchor.y = gridPosition.y
			if gridPosition.x < iconAnchor.x: iconAnchor.x = gridPosition.x
			
		var calculatedSnapDestination = placementLocation.cellID + iconAnchor.x + iconAnchor.y * columnCount
		
		iconAnchor = Vector2(2000,2000)
		
		inventoryItem.snapToCell(gridArray[calculatedSnapDestination], gridSize)
	emit_signal("inventory_changed", getItems())


func pickItem(): 
	if not currentSlot or not currentSlot.itemRef:
		return
	
	if currentSlot.isLoot && numberOfItemsTakenFromLoot() >= maximumItemsFromLootAvailable:
		return
		
	itemHeld = currentSlot.itemRef
	itemHeld.selected = true
	
	itemHeld.get_parent().remove_child(itemHeld)
	add_child(itemHeld)
	itemHeld.global_position = get_global_mouse_position()
	
	if currentSlot.isLoot:
		currentSlot.state = InventoryCell.States.FREE
		currentSlot.itemRef = null
	else:
		for gridPosition in itemHeld.gridPositions:
			var gridPositionToCheck = itemHeld.gridCell.cellID + gridPosition[0] + gridPosition[1] * columnCount
			gridArray[gridPositionToCheck].state = InventoryCell.States.FREE
			gridArray[gridPositionToCheck].itemRef = null
	
	checkCellAvailability(currentSlot)
	updateGridColors(currentSlot)

func placeItem():
	if not canPlace or not currentSlot:
		return
	
	itemHeld.global_position = get_global_mouse_position()
	
	var calculateCellId = currentSlot.cellID + iconAnchor.x + iconAnchor.y * columnCount 
	itemHeld.snapToCell(gridArray[calculateCellId], gridSize)
	
	itemHeld.get_parent().remove_child(itemHeld)
	inventoryGridContainer.add_child(itemHeld)
	
	if !itemHeld.previousGridCell.isLoot:
		itemHeld.previousGridCell = itemHeld.gridCell
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
	
func returnItem():
	
	itemHeld.snapToCell(itemHeld.previousGridCell, gridSize)
	
	itemHeld.gridCell = itemHeld.previousGridCell
	itemHeld.get_parent().remove_child(itemHeld)
	if itemHeld.previousGridCell.isLoot:
		itemHeld.previousGridCell.add_child(itemHeld)
		itemHeld.previousGridCell.state = InventoryCell.States.TAKEN
		itemHeld.previousGridCell.itemRef = itemHeld
	else:
		inventoryGridContainer.add_child(itemHeld)
		for gridPosition in itemHeld.gridPositions:
			var gridPositionToCheck = itemHeld.gridCell.cellID + gridPosition[0] + gridPosition[1] * columnCount
			gridArray[gridPositionToCheck].state = InventoryCell.States.TAKEN
			gridArray[gridPositionToCheck].itemRef = itemHeld
	
	itemHeld = null
	clearGrid()
	
	#after item placed
	updateSynergies()
	emit_signal("inventory_changed", getItems())

func checkCellAvailability(aCell):
	if aCell.isLoot:
		canPlace = false if aCell.itemRef else true
		return
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
	if aCell.isLoot:
		if canPlace:
			aCell.setColor(InventoryCell.States.FREE)
		else:
			aCell.setColor(InventoryCell.States.TAKEN)
		return
		
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
	for cell in soulLoot.get_children():
		cell.setColor(InventoryCell.States.DEFAULT)
	for cell in gridArray:
		cell.setColor(InventoryCell.States.DEFAULT)

func rotateItem():
	itemHeld.rotateItem()
	clearGrid()
	if currentSlot:
		_on_cell_mouse_entered(currentSlot)

func numberOfItemsTakenFromLoot():
	var items = 0
	for cell in soulLoot.get_children():
		if cell.itemRef == null && cell.visible:
			items += 1 
	return items

func updateItemsPreviousPositions():
	for item in getItems():
		item.previousGridCell = item.gridCell
	
func _on_soul_loot_ready(items : Array[Item]):
	
	var tween = create_tween()
	
	soulDropContainer.visible = true
	for cell in soulLoot.get_children():
		cell.visible = false
	
	var cellPointer = 0
	for item in items:
		var inventoryItem = inventoryItemScene.instantiate()
		var cell = soulLoot.get_child(cellPointer)
		inventoryItem.loadItem(item)
		inventoryItem.itemId = inventoryItem.get_instance_id()
		inventoryItem.previousGridCell = cell
		inventoryItem.gridCell = cell
		
		cell.visible = true
		cell.add_child(inventoryItem)
		cell.itemRef = inventoryItem
		inventoryItem.position = soulTexture.position
		#animacja od soul texture rect -> inventory sell
		tween.parallel().tween_property(\
			inventoryItem, \
			"position", \
			cell.position, \
			1)
		
		cellPointer += 1
	

func _on_cell_mouse_entered(aCell):
	iconAnchor = Vector2(2000,2000)
	currentSlot = aCell
	if itemHeld:
		checkCellAvailability(aCell)
		updateGridColors(aCell)
		
func _on_cell_mouse_exited(aCell):
	clearGrid()


func _on_ready():
	inventoryReady = true


func _on_ready_button_pressed():
	clearLoot()
	lootClosed.emit()


func _on_visibility_changed():
	print_debug("inventory: ", position, " g: ", global_position)
	print_debug("rect: ", get_node("ColorRect").position, " g: ", get_node("ColorRect").global_position)
	print_debug("outerContainer: ", %GridOuterContainer.position, " g: ", %GridOuterContainer.global_position)
	print_debug("gridContainer: ", %InventoryGridContainer.position, " g: ", %InventoryGridContainer.global_position)
	updateItemsPreviousPositions()
