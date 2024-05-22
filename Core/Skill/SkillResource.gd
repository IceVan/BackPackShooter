extends Resource
class_name SkillResource

@export var stats : Dictionary = {}
@export var skillStatsModifications : Dictionary = {}
@export var cooldown : float = 1.0
@export var type : Enums.Skills
@export var tags : Array[Enums.Tags] = []

#AI STUFF
@export var minRange : int = 0
@export var maxRange : int = 0

#SKILL BONUSES
@export var multiplicationFactor : float = 1.0
@export var dotMultiplicationFactor : float = 1.0
@export var flatBonus : int = 0
@export var dotFlatBonus : int = 0

