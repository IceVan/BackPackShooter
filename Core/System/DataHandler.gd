extends Node

var itemData = {}
@onready var itemDataPath = "res://Data/items_data.json"

func _ready():
	loadData(itemDataPath)
	pass # Replace with function body.

func loadData(path):
	assert(FileAccess.file_exists(path), "Could not find item data file")
	var itemDataFile = FileAccess.open(path, FileAccess.READ)
	itemData = JSON.parse_string(itemDataFile.get_as_text())
	itemDataFile.close()
