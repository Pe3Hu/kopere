extends MarginContainer


@onready var rings = $Rings
@onready var hexs = $Hexs

var units = {}


func _ready() -> void:
	init_units()


func init_units() -> void:
	var l = 6
	var index = 0
	add_unit(Vector3())
	
	for _i in 3:
		var ring = rings.get_children().back()
		
		for unit in ring.get_children():
			add_neighbors(unit)
	
	update_neighbors()
	
	var unit = units[Vector3(1, -1, 0)]
	for neighbor in unit.neighbors:
		neighbor.switch_indicators()


func add_unit(grid_: Vector3) -> void:
	var unit = Global.scene.unit.instantiate()
	add_child(unit)
	unit.grid = grid_
	units[unit.grid] = unit
	unit.ring = get_ring_by_grid(unit.grid)
	unit.set_index(units.keys().size() - 1)
	remove_child(unit)
	var ring = get_ring(unit.ring)
	ring.add_child(unit)
	
	var skeleton_title = 0
	var hex = Global.scene.hex.instantiate()
	hexs.add_child(hex)
	hex.unit = unit
	unit.hex = hex
	hex.position = get_hex_position_by_grid(unit.grid)
	hex.label.text = str(unit.index)
	
	if Global.dict.skeleton.title[skeleton_title].thickness.has(unit.index):
		var thickness = Global.dict.skeleton.title[skeleton_title].thickness[unit.index]
		unit.set_armor_thickness(thickness)
	else:
		hex.visible = false


func get_ring_by_grid(grid_: Vector3) -> int:
	var ring = max(abs(grid_.x), abs(grid_.y))
	ring = max(abs(grid_.z), ring)
	return ring


func get_ring(layer_: int) -> GridContainer:
	var ring = null
	
	if rings.get_child_count() <= layer_:
		ring = GridContainer.new()
		ring.columns = 6
		ring.name = str(rings.get_child_count())
		rings.add_child(ring)
	else:
		ring = rings.get_node(str(layer_))
	
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


func add_neighbors(unit_: MarginContainer) -> void:
	for direction in Global.dict.neighbor.cube:
		var grid = unit_.grid + direction
		
		if !units.has(grid):
			add_unit(grid)


func update_neighbors() -> void:
	for grid in units:
		var unit = units[grid]
		
		for direction in Global.dict.neighbor.cube:
			var neighbor_grid = direction + grid
			
			if units.has(neighbor_grid):
				var neighbor = units[neighbor_grid]
				
				if !unit.neighbors.has(neighbor):
					unit.neighbors[neighbor] = direction
					neighbor.neighbors[unit] = -direction
