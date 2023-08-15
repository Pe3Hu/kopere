extends Node


var rng = RandomNumberGenerator.new()
var num = {}
var dict = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}
var vec = {}
var scene = {}
var stats = {}


func init_num() -> void:
	num.index = {}
	num.index.unit = 0
	num.index.pattern = 0
	num.index.mechanism = 0
	num.index.shot = 0
	num.index.iteration = 0
	num.index.weapon = 0
	
	num.size = {}
	num.size.unit = {}
	num.size.unit.R = 24
	num.size.unit.r = num.size.unit.R * sqrt(3) / 2
	
	num.size.module = {}
	num.size.module.n = 6
	num.size.module.col = num.size.module.n - 1#num.size.module.n*2-1
	num.size.module.row = num.size.module.n - 1#num.size.module.n*2-1
	
	num.size.framework = {}
	num.size.framework.col = 11
	num.size.framework.row = 11


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 0,-1),
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
		],
		[
			Vector2( 1,-1),
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	dict.neighbor.cube = [
		Vector3(0, -1, +1),
		Vector3(+1, -1, 0),
		Vector3(+1, 0, -1),
		Vector3(0, +1, -1), 
		Vector3(-1, +1, 0),
		Vector3(-1, 0, +1),   
	]
	
	dict.team = {}
	dict.team.opponent = {}
	dict.team.opponent["attackers"] = "defenders"
	dict.team.opponent["defenders"] = "attackers"
	
	stats.weapon = {}
	
	init_scope()
	init_corner()
	init_pentahex()
	init_skeleton()
	init_weapon()
	


func init_scope() -> void:
	dict.scope = {}
	dict.scope.scatter = {}
	
	for _i in 4:
		if !dict.scope.scatter.has(_i):
			dict.scope.scatter[_i] = 1
		
		for _j in _i + 1:
			dict.scope.scatter[_i] += 6 * _j


func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [3,4,6]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2*PI*_i/corners_-PI/2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex


func init_pentahex() -> void:
	dict.pentahex = {}
	dict.pentahex.indexs = {}
	var path = "res://asset/json/pentahex_kopere.json"
	var dict_ = load_data(path)
	
	for key in dict_.keys():
		dict.pentahex.indexs[key] = dict_[key]


func init_skeleton() -> void:
	dict.skeleton = {}
	dict.skeleton.title = {}
	var path = "res://asset/json/skeleton_kopere.json"
	var array = load_data(path)
	var rings = ["I","II","III"]
	
	for data in array:
		var title = int(data.title)
		dict.skeleton.title[title] = {}
		dict.skeleton.title[title].ring = {}
		dict.skeleton.title[title].thickness = {}
		
		data.erase(title)
		
		for ring in rings:
			dict.skeleton.title[title].ring[ring] = data[ring]
			data.erase(ring)
		
		for key in data:
			var index = int(key)
			
			if data[key] != 0:
				dict.skeleton.title[title].thickness[index] = data[key]


func init_weapon() -> void:
	dict.weapon = {}
	dict.weapon.title = {}
	var path = "res://asset/json/weapon_kopere.json"
	var array = load_data(path)
	
	for data in array:
		dict.weapon.title[data.title] = {}
		dict.weapon.title[data.title].distance = {}
		dict.weapon.title[data.title].distance.effective = {}
		dict.weapon.title[data.title].rate = {}
		dict.weapon.title[data.title].penetration = {}
		
		for key in data:
			var words = key.rsplit(" ")
			var flag = true
			
			for subkey in dict.weapon.title[data.title]:
				if words.has(subkey):
					flag = false
					var str = ""
					
					for _i in words.size():
						var word = words[_i]
						
						if word != subkey and word != "effective":
							if _i != 0:
								str += " "
							
							str += word
					
					if words.has("effective"):
						dict.weapon.title[data.title][subkey].effective[str] = data[key]
					else:
						dict.weapon.title[data.title][subkey][str] = data[key]
			
			if flag:
				dict.weapon.title[data.title][key] = data[key]
		
		
		dict.weapon.title[data.title].erase("title")


func init_arr() -> void:
	pass
	


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.firehill = load("res://scene/1/firehill.tscn")
	scene.milestone = load("res://scene/1/milestone.tscn")
	scene.icon = load("res://scene/1/icon.tscn")
	
	scene.mechanism = load("res://scene/2/mechanism.tscn")
	scene.target = load("res://scene/2/target.tscn")
	scene.hex = load("res://scene/2/hex.tscn")
	
	scene.unit = load("res://scene/2/unit.tscn")
	scene.reel = load("res://scene/3/reel.tscn")
	scene.cell = load("res://scene/3/cell.tscn")
	
	scene.weapon = load("res://scene/4/weapon.tscn")
	


func init_vec():
	vec.size = {}
	init_window_size()
	
	vec.size.unit = Vector2(80, 24)
	vec.size.cell = Vector2(vec.size.unit)
	vec.size.letter2 = Vector2(31, 23)
	vec.size.letter3 = Vector2(46, 23)
	
	
	num.size.unit.R = vec.size.unit.x / 2 * 1.25
	num.size.unit.r =  num.size.unit.R * sqrt(3) / 2


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func _ready() -> void:
	init_num()
	init_dict()
	init_arr()
	init_node()
	init_scene()
	init_vec()


func save(path_: String, data_: String):
	var file = FileAccess.open(path_, FileAccess.WRITE_READ)
	file.store_string(data_)
	file.close()


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null


func check_array_has_grid(parent_: MarginContainer, grid_: Vector2) -> bool:
	return grid_.y >= 0 and grid_.x >= 0 and grid_.y < parent_.borders.y and grid_.x < parent_.borders.x


func check_grid_on_screen(parent_: MarginContainer, grid_: Vector2) -> bool:
	if check_array_has_grid(parent_, grid_):
		var unit = parent_.get_unit_by_grid(grid_)
		return unit.visible
	else:
		return false


func save_statistics(mechanism_: MarginContainer) -> void:
	var datas = {}
	
	for weapon in Global.stats.weapon:
		var data = {}
		#data.bullet = mechanism_.active_weapon.bullet
		#data.aim = mechanism_.aim
		data["firing range"] = Global.stats.weapon[weapon]
		data.avg = 0
	
		for shoots in Global.stats.weapon[weapon]:
			data.avg += shoots
		
		data.avg /= Global.stats.weapon[weapon].size()
		datas[weapon] = data
	print(datas)
	
	var time = Time.get_datetime_string_from_datetime_dict(Time.get_datetime_dict_from_system(), true)
	var path = "res://asset/stat/" + "stat" + ".json"
	var file_dict = load_data(path)
	file_dict[time] = datas
	var str = JSON.stringify(file_dict)
	save(path, str)
	
