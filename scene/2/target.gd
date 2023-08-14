extends MarginContainer


@onready var hexs = $Hexs

var skeleton = null
var grids = {}
var rings = []
var corners = {}


func _ready() -> void:
	skeleton = 2
	corners.min = Vector2()
	corners.max = Vector2()
	init_units()
	update_size()


func init_units() -> void:
	var l = 6
	var index = 0
	add_hex(Vector3())
	
	for _i in 3:
		var hexs = rings.back()
		
		for hex in hexs:
			add_neighbors(hex)
	
	update_neighbors()
	
	for hex in hexs.get_children():
		if hex.visible:
			#unit.hex.label.text = str(unit.index)
			hex.position = get_hex_position_by_grid(hex.grid)
			update_corners(hex.position)
		else:
			hex.clean()

	print(hexs.get_child_count())
	
#	var unit = units[Vector3(1, -1, 0)]
#
#	for neighbor in unit.neighbors:
#		neighbor.switch_indicators()


func add_hex(grid_: Vector3) -> void:
	var hex = Global.scene.hex.instantiate()
	hexs.add_child(hex)
	hex.target = self
	var unit = hex.unit
	hex.grid = grid_
	grids[hex.grid] = hex
	hex.ring = get_ring_by_grid(hex.grid)
	hex.set_index(grids.size() - 1)
	var ring = get_ring(hex.ring)
	ring.append(hex)
	
	if Global.dict.skeleton.title[skeleton].thickness.has(hex.index):
		var thickness = Global.dict.skeleton.title[skeleton].thickness[hex.index]
		hex.unit.set_armor_thickness(thickness)
	else:
		hex.visible = false


func get_ring_by_grid(grid_: Vector3) -> int:
	var ring = max(abs(grid_.x), abs(grid_.y))
	ring = max(abs(grid_.z), ring)
	return ring


func get_ring(layer_: int) -> Array:
	var ring = null
	
	if rings.size() <= layer_:
		ring = []
		rings.append(ring)
	else:
		ring = rings[layer_]
	
	return ring


func get_hex_position_by_grid(grid_: Vector3) -> Vector2:
	var vector = Vector2()
	var ls = []
	ls.append(grid_.x)
	ls.append(grid_.y)
	ls.append(grid_.z)
	var angle = {}
	angle.step = PI * 2 / ls.size()
	
	for _i in ls.size():
		var l = ls[_i]
		angle.current = angle.step * (_i)
		vector += Vector2.from_angle(angle.current) * Global.num.size.unit.R * l
	
	return vector  


func update_corners(vector: Vector2) -> void:
	if corners.min.y > vector.y:
		corners.min.y = vector.y
	if corners.min.x > vector.x:
		corners.min.x = vector.x
	if corners.max.y < vector.y:
		corners.max.y = vector.y
	if corners.max.x < vector.x:
		corners.max.x = vector.x


func add_neighbors(hex_: Polygon2D) -> void:
	for direction in Global.dict.neighbor.cube:
		var grid = hex_.grid + direction
		
		if !grids.has(grid):
			add_hex(grid)


func update_neighbors() -> void:
	for grid in grids:
		var unit = grids[grid]
		
		for direction in Global.dict.neighbor.cube:
			var neighbor_grid = direction + grid
			
			if grids.has(neighbor_grid):
				var neighbor = grids[neighbor_grid]
				
				if !unit.neighbors.has(neighbor):
					unit.neighbors[neighbor] = direction
					neighbor.neighbors[unit] = -direction


func update_size() -> void:
	corners.min.x -= Global.num.size.unit.R
	corners.min.y -= Global.num.size.unit.r
	corners.max.x += Global.num.size.unit.R
	corners.max.y += Global.num.size.unit.r
	
	custom_minimum_size = corners.max - corners.min
	hexs.position = -corners.min
