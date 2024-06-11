extends Area2D
class_name BaseBullet

@export var speed = 800.0
@export var maxDistance = 4000.0
@export var maxTimeToLive = 10.0
@export var direction = Vector2(0, 0)
@export var attackData : AttackResource

var distanceLeft = maxDistance
var timeToLive = maxTimeToLive

func _process(delta):
	distanceLeft -= speed * delta
	timeToLive -= delta
	if(distanceLeft <= 0 or timeToLive <= 0):
		destroy()
		
	move(delta)


func destroy():
	queue_free()

func move(delta):
	self.translate(direction * speed * delta)
	
func setCollisionMask(layers: Array, value: bool):
	for layer in layers:
		setCollisionMaskSingle(layer, value)

func setCollisionMaskSingle(layerNumber: int, value: bool):
	set_collision_mask_value(layerNumber, value)

func setCollisionLayer(layers: Array, value: bool):
	for layer in layers:
		setCollisionLayerSingle(layer, value)

func setCollisionLayerSingle(layerNumber: int, value: bool):
	set_collision_layer_value(layerNumber, value)

func onHit(area):
	if(area is HitboxComponent):
		area.onHit(self, attackData)
		processNextSkillInChain(area)

func _on_area_entered(area):
	onHit(area)
	queue_free()

func processNextSkillInChain(area):
	var skills = attackData.stats.get("SKILLS", [])
	for skill in skills:
		SkillManager.staticUse(\
			skill.get("SKILL_NAME",""),\
			attackData.source,\
			area.global_position,\
			[],\
			{"ATTACK" : attackData.stats.get("ATTACK",{})})
