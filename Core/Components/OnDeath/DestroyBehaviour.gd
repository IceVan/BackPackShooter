extends OnDeathBehaviour


func process(entity : Entity):
	super.process(entity)
	entity.queue_free()
