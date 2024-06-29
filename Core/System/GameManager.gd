extends Node2D
class_name GameManager

@onready var locationManager : LocationManager = $LocationManager

@export var playerToLoad : PackedScene
@export var userInterface : UI

var currentState = GameState.MAIN_MENU
var currentPlayer = null

var readyToPlay = false

signal goToNewMap
signal goToHuB
signal playerChanged

signal sceneExited

enum GameState { MAIN_MENU, MAP, HUB, PAUSED, PAUSED_UI }

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	userInterface.switchUI(currentState)
	userInterface.mainMenu.start_game.connect(startGame)
	userInterface.pause_pressed.connect(pauseGame)
	userInterface.escape_pressed.connect(goToMainMenu)
	userInterface.inventory_pressed.connect(openInventory)
	
	locationManager.locationReady.connect(_on_location_loaded)
	locationManager.soulsChanged.connect(userInterface.soulsBar._on_souls_changed)
	goToHuB.connect(locationManager._on_go_to_hub)
	goToNewMap.connect(locationManager._on_go_to_new_map)
	
	sceneExited.connect(BulletManager.onSceneExited)
	
	emit_signal("goToNewMap")
	

func startGame():
	if !readyToPlay:
		print_debug('Not loaded yet')
		return
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
	readyToPlay = false
	currentState = GameState.MAIN_MENU
	userInterface.switchUI(currentState)
	restartGameState()

func restartGameState():
	currentPlayer = null
	emit_signal("goToNewMap")

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
	
func _on_location_loaded(location):
	currentPlayer = createPlayer()
	location.add_child(currentPlayer)
	readyToPlay = true
	
