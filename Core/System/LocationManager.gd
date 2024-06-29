extends Node2D
class_name LocationManager

@export var soulScene : PackedScene
@export var locationToLoad : PackedScene
@export var fibSouls : int = 100
@export var fibNextSouls : int = 200

var soulsToPromote
var fibNextSoulsToPromote

var currentSouls = 0

var loadedLocation

signal locationReady
signal locationExited

signal soulsChanged


func isLocationReady():
	return true if loadedLocation else false

func getCollectibles():
	var node = null
	if isLocationReady():
		node = loadedLocation.get_node("Collectibles")
	return node

func spawnSoul(location : Vector2, amount : int):
	var soul = soulScene.instantiate()
	soul.global_position = location
	soul.soulCollected.connect(_on_souls_collected)
	soul.soulValue = amount
	getCollectibles().add_child(soul)

func _on_go_to_new_map():
	if(isLocationReady()):
		remove_child(loadedLocation)
		loadedLocation.queue_free()
	loadedLocation = locationToLoad.instantiate()
	add_child(loadedLocation)
	currentSouls = 0
	soulsToPromote = fibSouls
	fibNextSoulsToPromote = fibNextSouls
	locationReady.emit(loadedLocation)
	soulsChanged.emit(currentSouls, soulsToPromote)
	
	for collectible in loadedLocation.get_node("Collectibles").get_children():
		if collectible is SoulCollectible:
			collectible.soulCollected.connect(_on_souls_collected)
	
func _on_go_to_hub():
	pass

func _on_souls_collected(amount : int):
	currentSouls += amount
	if currentSouls > soulsToPromote:
		currentSouls -= soulsToPromote
		#fibbonachi
		var nextCelling = soulsToPromote + fibNextSoulsToPromote
		soulsToPromote = fibNextSoulsToPromote
		fibNextSoulsToPromote = nextCelling
	soulsChanged.emit(currentSouls, soulsToPromote)
	
