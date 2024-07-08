extends CanvasLayer
class_name UI

@onready var hud : CanvasLayer = %Hud
@onready var inventory : InventoryV2 = %Inventory2
@onready var mainMenu : MainMenu = %MainMenu

@onready var healthBar : ProgressBar = %Hud.healthBar
@onready var soulsBar : ProgressBar = %Hud.soulsBar

signal pause_pressed
signal escape_pressed
signal inventory_pressed

func switchUI(gameState : GameManager.GameState):
	match gameState:
		GameManager.GameState.MAIN_MENU:
			hud.hide()
			inventory.hide()
			inventory.soulDropContainer.hide()
			mainMenu.show()
		GameManager.GameState.MAP:
			hud.show()
			inventory.hide()
			inventory.soulDropContainer.hide()
			mainMenu.hide()
		GameManager.GameState.HUB:
			hud.hide()
			inventory.hide()
			inventory.soulDropContainer.hide()
			mainMenu.hide()
		GameManager.GameState.PAUSED:
			hud.show()
			inventory.hide()
			inventory.soulDropContainer.hide()
			mainMenu.hide()
		GameManager.GameState.PAUSED_INVENTORY:
			hud.show()
			inventory.show()
			inventory.soulDropContainer.hide()
			mainMenu.hide()
		GameManager.GameState.PAUSED_LOOT:
			hud.show()
			inventory.show()
			inventory.soulDropContainer.show()
			mainMenu.hide()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("PAUSE"):
		pause_pressed.emit()
	if Input.is_action_just_pressed("ESC"):
		escape_pressed.emit()
	if Input.is_action_just_pressed("INVENTORY"):
		inventory_pressed.emit()


func _on_control_item_rect_changed():
	print_debug("inventory rect changed")
