extends ProgressBar

@onready var timer = $Timer
@onready var futureSoulsBar : ProgressBar = $FutureSoulsBar


func initBars(max : int):
	max_value = max
	value = 0
	futureSoulsBar.max_value = max
	futureSoulsBar.value = 0

func updateSouls(max : int, current : int):
	if max > max_value:
		max_value = max
		value = 0
		futureSoulsBar.max_value = max
		futureSoulsBar.value = current
	elif futureSoulsBar.value > current:
		futureSoulsBar.value = current
		timer.start()

func _on_timer_timeout():
	value = futureSoulsBar.value
