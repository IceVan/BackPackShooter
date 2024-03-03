extends OnDeathBehaviour


func process(entity : Entity):
	entity.queue_free()
