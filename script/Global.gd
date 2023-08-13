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
		Vector3(+1, 0, -1), Vector3(+1, -1, 0), Vector3(0, -1, +1), 
		Vector3(-1, 0, +1), Vector3(-1, +1, 0), Vector3(0, +1, -1), 
	]
	
	
	
	dict.team = {}
	dict.team.opponent = {}
	dict.team.opponent["attackers"] = "defenders"
	dict.team.opponent["defenders"] = "attackers"
	
	init_corner()
	init_pentahex()
	


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
	var path = "res://asset/json/pentahex_data.json"
	var dict_ = load_data(path)
	
	for key in dict_.keys():
		dict.pentahex.indexs[key] = dict_[key]


func init_title() -> void:
	dict.title = {}
	var path = "res://asset/json/wohnwagen_title_data.json"
	var array = load_data(path)
	
	for key in array.front().keys():
		dict.title[key] = []
	
	for dict_ in array:
		for key in dict_.keys():
			dict.title[key].append(dict_[key])


func init_arr() -> void:
	pass


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	#scene.gebirge = load("res://scene/0/gebirge.tscn")
	#scene.framework = load("res://scene/0/framework.tscn")
	#scene.module = load("res://scene/0/module.tscn")
	#scene.pattern = load("res://scene/1/pattern.tscn")
	#scene.unit = load("res://scene/1/unit.tscn")
	
	scene.factory = load("res://scene/98/factory.tscn")
	scene.framework = load("res://scene/98/framework.tscn")
	scene.module = load("res://scene/98/module.tscn")
	scene.unit = load("res://scene/98/unit.tscn")
	scene.pattern = load("res://scene/98/pattern.tscn")
	
	
	scene.firehill = load("res://scene/1/firehill.tscn")
	scene.milestone = load("res://scene/1/milestone.tscn")
	scene.icon = load("res://scene/1/icon.tscn")
	scene.target = load("res://scene/2/target.tscn")
	scene.mechanism = load("res://scene/2/mechanism.tscn")
	scene.unit = load("res://scene/2/unit.tscn")
	scene.reel = load("res://scene/3/reel.tscn")
	scene.cell = load("res://scene/3/cell.tscn")
	
	


func init_vec():
	vec.size = {}
	init_window_size()
	
	vec.size.unit = Vector2(80, 24)
	vec.size.cell = Vector2(vec.size.unit)
	vec.size.letter2 = Vector2(31, 23)
	vec.size.letter3 = Vector2(46, 23)


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
	var path = path_+".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)
	file.close()


func load_data(path_: String):
	var file = FileAccess.open(path_,FileAccess.READ)
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
