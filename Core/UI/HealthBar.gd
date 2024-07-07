extends ProgressBar

@onready var timer = $Timer
@onready var damageBar : ProgressBar = $DamageBar


func initBars(maxHp : int):
	max_value = maxHp
	value = maxHp
	damageBar.max_value = maxHp
	damageBar.value = maxHp

func updateHealth(oldHealth : int, currentHealth : int):
	if value > currentHealth:
		value = currentHealth
		timer.start()
	elif value < currentHealth:
		value = currentHealth
		damageBar.value = currentHealth

func updateMaxHealth(maxHp : int):
	max_value = maxHp
	damageBar.max_value = maxHp

func _on_timer_timeout():
	damageBar.value = value
