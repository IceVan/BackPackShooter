extends ProgressBar

@onready var timer = $Timer
@onready var futureSoulsBar : ProgressBar = $FutureSoulsBar


func initBars(max : int):
	max_value = max
	value = 0
	futureSoulsBar.max_value = max
	futureSoulsBar.value = 0

func updateSouls(current : int, max : int):
	if max > max_value:
		max_value = max
		value = 0
		futureSoulsBar.max_value = max
		futureSoulsBar.value = current
		timer.start()
	elif futureSoulsBar.value < current:
		futureSoulsBar.value = current
		timer.start()

func _on_timer_timeout():
	value = futureSoulsBar.value

func _on_souls_changed(current : int, max : int):
	updateSouls(current, max)
