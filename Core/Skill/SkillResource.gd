extends Resource
class_name SkillResource

@export var stats : Dictionary = {}
@export var skillStatsModifications : Dictionary = {}
@export var cooldown : float = 1.0
@export var type : Enums.Skills
@export var tags : Array[Enums.Tags] = []
@export var actionButtons : Array[Enums.ActionButton] = []
