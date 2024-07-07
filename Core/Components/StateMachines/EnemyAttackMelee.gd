extends State
class_name EnemyAttackMelee

@export var entity : Entity
var skill

func enter(val = null):
	skill = val
	
func exit(val = null):
	pass
	
func update(_delta):
	pass
	
func physicsUpdate(_delta):
	if(skill.isReady):
		skill.use(entity)
	
	#TODO przeniesc do update i sprawdzic czy animacja sie skonczyła
	Transitioned.emit(self, "ENEMYIDLE")
