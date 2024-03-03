extends Resource
class_name MiscStatResource


@export var speed : float = 0
@export var collectionRange : float = 0
@export var goldBonus : float = 0
@export var expBonus : float = 0
@export var lightRadius : float = 0
@export var luck : int = 0
@export var tags : Array[Enums.Tags] = []


func add(miscStatResource : MiscStatResource) -> MiscStatResource :
	self.speed += miscStatResource.def
	self.collectionRange += miscStatResource.health
	self.goldBonus += miscStatResource.regenPerSecond
	self.expBonus += miscStatResource.shield
	self.lightRadius += miscStatResource.shieldDuration
	self.luck += miscStatResource.luck
	for tag in miscStatResource.tags :
		if(!tags.has(tag)):
			tags.append(tag)
	return self
