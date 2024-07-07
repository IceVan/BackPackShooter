extends Control
class_name MainMenu

signal start_game()

@onready var buttonsVB = %ButtonsVB

func _ready():
	focusButton()

func focusButton():
	if buttonsVB:
		var button = buttonsVB.get_child(0)
		if button is Button:
			button.grab_focus()

func _on_start_pressed():
	start_game.emit()

func _on_exit_pressed():
	get_tree().quit()
