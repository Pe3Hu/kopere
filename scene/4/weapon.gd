extends MarginContainer


var title = null
var bullet = null
var clip = {}


func init(title_: String)-> void:
	title = title_
	clip.max = Global.dict.weapon.title[title].clip
	equip_bullets("standard")


func equip_bullets(type_: String) -> void:
	bullet = type_
	clip.current = int(clip.max)


func get_penetration(vulnerable_: bool) -> int:
	if vulnerable_:
		return Global.dict.weapon.title[title].penetration["critical armor"]
	else:
		return Global.dict.weapon.title[title].penetration["standard armor"]


func get_damage() -> int:
	var damage = Global.dict.weapon.title[title]["projectile damage"]
	return damage


func get_scatter() -> int:
	var scatter = Global.dict.weapon.title[title].scatter
	return scatter
