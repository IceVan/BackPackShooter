extends CanvasLayer
class_name UI

@onready var hud : CanvasLayer = %Hud
@onready var inventory : Inventory = %Inventory
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
			mainMenu.show()
		GameManager.GameState.MAP:
			hud.show()
			inventory.hide()
			mainMenu.hide()
		GameManager.GameState.HUB:
			hud.hide()
			inventory.hide()
			mainMenu.hide()
		GameManager.GameState.PAUSED:
			hud.show()
			inventory.hide()
			mainMenu.hide()
		GameManager.GameState.PAUSED_UI:
			hud.show()
			inventory.show()
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
