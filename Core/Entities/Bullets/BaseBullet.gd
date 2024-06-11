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
	#TODO
	#for skill in skills:
		#var sceneResource = SkillToSceneDictionary.fromString.get(skill.get("SKILL_NAME",""), null)
				#
		#if sceneResource:
			#var skillNode = sceneResource.instantiate()
					#
			#if(skill.has("SKILL_MULTIPLICATION_FACTOR")):
				#skillNode.multiplicationFactor = skill.get("SKILL_MULTIPLICATION_FACTOR", 1.0)
			#if(skill.has("SKILL_DOT_MULTIPLICATION_FACTOR")):
				#skillNode.dotMultiplicationFactor = skill.get("SKILL_DOT_MULTIPLICATION_FACTOR", 1.0)
			#if(skill.has("SKILL_FLAT_BONUS")):
				#skillNode.flatBonus = skill.get("SKILL_FLAT_BONUS", 0)
			#if(skill.has("SKILL_DOT_FLAT_BONUS")):
				#skillNode.dotFlatBonus = skill.get("SKILL_DOT_FLAT_BONUS", 0)
			#if(skill.has("SKILLS")):
				#skillNode.stats["SKILLS"] = skill.get("SKILLS", [])
			#
			#sceneResource.staticUse(attackData.source, area.global_position, {"ATTACK" : attackData.stats.get("ATTACK",{})})
			#
