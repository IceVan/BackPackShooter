extends Node2D
class_name GameManager

@export var playerToLoad : PackedScene
@export var sceneToLoad : PackedScene
@export var userInterface : UI

var currentState = GameState.MAIN_MENU
var currentScene = null
var currentPlayer = null

signal locationChanged #TODO
signal playerChanged

signal sceneExited

enum GameState { MAIN_MENU, MAP, HUB, PAUSED, PAUSED_UI }

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	prepareTree()
	userInterface.switchUI(currentState)
	userInterface.mainMenu.start_game.connect(startGame)
	userInterface.pause_pressed.connect(pauseGame)
	userInterface.escape_pressed.connect(goToMainMenu)
	userInterface.inventory_pressed.connect(openInventory)
	
	sceneExited.connect(BulletManager.onSceneExited)
	

func startGame():
	currentState = GameState.MAP
	userInterface.switchUI(currentState)
	get_tree().paused = false

func pauseGame():
	get_tree().paused = !get_tree().paused

func goToMainMenu():
	if currentState == GameState.MAP || currentState == GameState.HUB:
		get_tree().paused = true
		currentState = GameState.MAIN_MENU
		userInterface.switchUI(currentState)
	elif currentState == GameState.MAIN_MENU || currentState == GameState.PAUSED_UI:
		currentState = GameState.MAP #MAP / HUB
		userInterface.switchUI(currentState)
		get_tree().paused = false

func openInventory():
	if currentState == GameState.MAP || currentState == GameState.HUB:
		get_tree().paused = true
		currentState = GameState.PAUSED_UI
		userInterface.switchUI(currentState)
	elif currentState == GameState.PAUSED_UI:
		currentState = GameState.MAP #MAP / HUB
		userInterface.switchUI(currentState)
		get_tree().paused = false

func pauseAfterDeath():
	get_tree().paused = true
	currentState = GameState.MAIN_MENU
	userInterface.switchUI(currentState)
	restartGameState()

func restartGameState():
	remove_child(currentScene)
	remove_child(currentPlayer)
	currentScene = null
	currentPlayer = null
	prepareTree()
	
func prepareTree():
	currentScene = sceneToLoad.instantiate()
	currentScene.add_child(createPlayer())
	add_child(currentScene)
	move_child(currentScene, 0)

func createPlayer() -> Entity:
	currentPlayer = playerToLoad.instantiate()
	userInterface.healthBar.initBars(currentPlayer.healthComponent.maxHealth)
	currentPlayer.healthComponent.died.connect(_on_player_death)
	currentPlayer.healthComponent.healthChanged.connect(userInterface.healthBar.updateHealth)
	currentPlayer.healthComponent.maxHealthChanged.connect(userInterface.healthBar.updateMaxHealth)
	playerChanged.emit(currentPlayer)
	return currentPlayer
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_death():
	pauseAfterDeath()
	sceneExited.emit()
