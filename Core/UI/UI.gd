extends CanvasLayer
class_name UI

@onready var hud : CanvasLayer = %Hud
@onready var inventory : Inventory = %Inventory
@onready var mainMenu : MainMenu = %MainMenu

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
	pass
