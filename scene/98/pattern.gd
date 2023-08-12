extends MarginContainer


var indexs = []
var letter = null
var module = null
var units = []


func set_units() -> void:
	for index in indexs:
		var unit = module.units.get_child(index)
		units.append(unit)
	
	#print(indexs, units)
