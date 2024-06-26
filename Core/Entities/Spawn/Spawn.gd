extends Marker2D
class_name Spawn

@export var spawnEntity : PackedScene
@export var entitiesAdditionalItems : Array[Item] = []
@export var amount : int = 1
@export var delayBetweenEntities : float = 0.1
@export var timer : Timer
@export var cooldown : float = 10.0


func _ready():
	timer.wait_time = cooldown
	timer.start()


func _process(delta):
	pass

func spawn():
	if get_tree():
		if amount > 1 && get_tree(): await get_tree().create_timer(delayBetweenEntities).timeout
		var position = global_position + VectorUtilsGlobal.getRandomInsideCircle(gizmo_extents)
		var entity : Entity = spawnEntity.instantiate()
		entity.inventoryComponent.addItems(entitiesAdditionalItems)
		entity.global_position = position
		#TODO przerzucić do enemy managera
		get_parent().add_child(entity)
	if timer:
		timer.start()


func _on_timer_timeout():
	spawn()
