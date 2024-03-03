extends Resource
class_name DefenceStatResource


@export var def : int = 0
@export var health : int = 0
@export var regenPerSecond : float = 0
@export var shield : int = 0
@export var shieldDuration : int = 0
@export var tags : Array[Enums.Tags] = []

func add(defenceStatResource : DefenceStatResource) -> DefenceStatResource :
	self.def += defenceStatResource.def
	self.health += defenceStatResource.health
	self.regenPerSecond += defenceStatResource.regenPerSecond
	self.shield += defenceStatResource.shield
	self.shieldDuration += defenceStatResource.shieldDuration
	for tag in defenceStatResource.tags :
		if(!tags.has(tag)):
			tags.append(tag)
	return self
