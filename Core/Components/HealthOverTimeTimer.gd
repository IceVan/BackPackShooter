extends Timer
class_name HealthOverTimeTimer

@export var data : Array = [] 

@onready var healthComponent : HealthComponent = get_parent()

func addData(damage : int, seconds : int = 10, tags : Array = []):
	if(data.size() >= healthComponent.maximumOverTimeStatuses):
		data.pop_front()
	
	data.append({
		"DMG" = damage,
		"SEC" = seconds,
		"PERSEC" = ceili(damage/seconds),
		"TAGS" = tags
	})

func _on_timeout():
	#DEBUG INFO
	#if(data.size() > 0):
		#print_debug(healthComponent.parent.name, " #size: ", data.size(), " #data: ", data)
	
	#TODO tags
	if(!healthComponent):
		push_error("HealthOverTimeTimer should be child of HealthComponent. Parent: ", get_parent())
	else:
		var dot = 0
		var hot = 0
		var rowsToDelete = []
		for row in data:
			var index = 0
			if(row.has("DMG") && row.has("SEC")):
				if(row.get("DMG") > 0):
					dot = dot + row.get("PERSEC")
					row["DMG"] = row["DMG"] - row["PERSEC"]
					row["SEC"] = row["SEC"] - 1
				else:
					hot = hot - row.get("PERSEC")
					row["DMG"] = row["DMG"] - row["PERSEC"]
					row["SEC"] = row["SEC"] - 1
				
				if(row.get("DMG") <= 0):
					rowsToDelete.append(index)
			index = index + 1
		rowsToDelete.reverse()
		
		for index in rowsToDelete:
			data.remove_at(index)
		
		healthComponent.regenerate(hot)
		healthComponent.damage(AttackResource.new({"ATTACK" : {"DMG" : dot}},[]), false)
		healthComponent.passiveRegenerate()
