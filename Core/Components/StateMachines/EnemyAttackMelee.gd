extends State
class_name EnemyAttackMelee

@export var entity : Entity

func enter(val = null):
	if(val.isReady):
		val.use(entity, val.associatedItem)
	
	#TODO przeniesc do update i sprawdzic czy animacja sie skonczyła
	Transitioned.emit(self, "ENEMYIDLE")
	
func exit(val = null):
	pass
	
func update(_delta):
	pass
	
func physicsUpdate(_delta):
	pass
