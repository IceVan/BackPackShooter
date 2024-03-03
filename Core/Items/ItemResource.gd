extends Resource
class_name Item

@export var stats : Dictionary = {}
@export var skills : Array[SkillResource] = []
@export var synergies : Array[SynergyResource] = []
@export var tags : Array[Enums.Tags] = []
@export var img : Texture2D
