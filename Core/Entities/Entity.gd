extends CharacterBody2D
class_name Entity

var uuid

@export var baseStats : Dictionary = {}
var stats : Dictionary = {}

var targetPosition : Vector2

#@export var attackComponent :AttackComponent
@export var defenseComponent :DefenseComponent
@export var healthComponent :HealthComponent
@export var onDeathComponent :OnDeathComponent
@export var controllComponent :ControllComponent
@export var skillsComponent :SkillsComponent
@export var inventoryComponent :InventoryComponent
@export var collectibleMagnesComponent :CollectibleMagnesComponent


func _ready():
	updateStats()
	if(skillsComponent): skillsComponent.startAll(self)
	

func _physics_process(delta):
	if(controllComponent):
		controllComponent.processInput(delta)
	if(collectibleMagnesComponent):
		collectibleMagnesComponent.onUpdate(delta)
	move_and_slide()

func destroy():
	if onDeathComponent:
		onDeathComponent.processDeath()
	else: 
		self.get_parent().remove_child(self)
		self.queue_free()


#func getAttackComponent():
#	return attackComponent
	
func recieveDamage(attack : AttackResource):
	if(healthComponent && defenseComponent):
		healthComponent.damage(defenseComponent.modifyAttack(attack))
	elif(healthComponent):
		healthComponent.damage(attack)
		
func isAlive() -> bool:
	return healthComponent.isAlive()
	
func isPlayer() -> bool:
	return controllComponent is PlayerController

func getItems() -> Array[Item]:
	var items = [] as Array[Item]
	if(inventoryComponent):
		items.append_array(inventoryComponent.items)
	return items

func updateStats():
	stats = baseStats.duplicate(true)
	if(inventoryComponent): GUtils.addToStats(stats, inventoryComponent.getStatsFromItems())
	if(controllComponent): controllComponent.speed = GUtils.getNmericProperty(stats, "STATS", "SPEED", 100)

func _on_health_component_died():
	ShowStatistics.enemyKilled()
	destroy()

#func _on_health_component_health_changed(oldHealth, currentHealth):
#	pass
