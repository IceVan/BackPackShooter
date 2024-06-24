extends Node2D
class_name GameManager

@export var playerToLoad : PackedScene
@export var sceneToLoad : PackedScene
@export var userInterface : UI

var currentState = GameState.MAIN_MENU
var currentScene = null
var currentPlayer = null

enum GameState { MAIN_MENU, MAP, HUB, PAUSED, PAUSED_UI }

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	prepareTree()
	userInterface.switchUI(currentState)
	userInterface.mainMenu.start_game.connect(startGame)

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
	elif currentState == GameState.MAIN_MENU:
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
	currentPlayer = playerToLoad.instantiate()
	currentScene.add_child(currentPlayer)
	add_child(currentScene)
	move_child(currentScene, 0)
	currentPlayer.healthComponent.died.connect(_on_player_death)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("PAUSE"):
		#doesnt work, should be in UI and passed via signals since they work even if paused
		#pauseGame()
		pass
	if Input.is_action_just_pressed("ESC"):
		#doesnt work from menu, should be in UI and passed via signals since they work even if paused
		goToMainMenu()
		pass

func _on_player_death():
	pauseAfterDeath()
