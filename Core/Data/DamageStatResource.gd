extends Resource
class_name DamageStatResource

@export var instantDamage : int = 0
@export var dot : int = 0
@export var dotDuration : int = 0
@export var tags : Array[Enums.Tags] = []

func add(damageStatResource : DamageStatResource) -> DamageStatResource :
	self.instantDamage += damageStatResource.instantDamage
	self.dot += damageStatResource.dot
	self.dotDuration += damageStatResource.dotDuration
	for tag in damageStatResource.tags :
		if(!tags.has(tag)):
			tags.append(tag)
	return self
