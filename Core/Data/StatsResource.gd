extends Resource
class_name StatsResource

@export var damageStat : Array[DamageStatResource] = []
@export var defenceStat : DefenceStatResource = DefenceStatResource.new()
@export var healingStat : Array[HealingStatResource] =[]
@export var miscStat : MiscStatResource = MiscStatResource.new()

func add(stats : StatsResource) -> StatsResource : 
	damageStat.append_array(stats.damageStat)
	if(defenceStat):
		defenceStat.add(stats.defenceStat)
	else : 
		defenceStat = stats.defenceStat
	healingStat.append_array(stats.healingStat)
	if(miscStat):
		miscStat.add(stats.miscStat)
	else:
		miscStat = stats.miscStat
	return self
