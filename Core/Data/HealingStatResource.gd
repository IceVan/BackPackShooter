extends Resource
class_name HealingStatResource

@export var instantHealing : int = 0
@export var hot : int = 0
@export var hotDuration : int = 0
@export var tags : Array[Enums.Tags] = []

func add(healingStatResource : HealingStatResource) -> HealingStatResource :
	self.instantHealing += healingStatResource.instantHealing
	self.hot += healingStatResource.hot
	self.hotDuration += healingStatResource.hotDuration
	for tag in healingStatResource.tags :
		if(!tags.has(tag)):
			tags.append(tag)
	return self
