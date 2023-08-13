extends MarginContainer


@onready var rings = $Rings

var units = {}


func _ready() -> void:
	init_units()



func init_units() -> void:
	var l = 6
	var index = 0
	add_unit(Vector3())
	
	for _i in 2:
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
	unit.set_armor_thickness(3)
	remove_child(unit)
	var ring = get_ring(unit.ring)
	ring.add_child(unit)


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


func init_units_old() -> void:
	var lengths = []
	var index = 0
	var n = 6
	var layers = {}
	layers.standard = [4,4,4,5,5]
	layers.options = []
	
	for _i in 4:
		var length = _i * n
		lengths.append(length)
	
	lengths[0] = 1
	
	for _i in lengths.size():
		var length = lengths[_i]
		var ring = GridContainer.new()
		ring.columns = n
		ring.name = str(_i)
		rings.add_child(ring)
		
		for _j in length:
			var unit = Global.scene.unit.instantiate()
			ring.add_child(unit)
			units.append(unit)
			unit.target = self
			unit.ring = _i
			unit.set_index(index)
			index += 1
		
		for _j in _i:
			var unit = ring.get_child(_j)
			unit.set_armor_thickness(3)
		
		if _i == 0:
			var unit = ring.get_child(0)
			unit.set_armor_thickness(3)
		
		for unit in ring.get_children():
			if unit.armor.label.text == "":
				if layers.options.is_empty():
					layers.options.append_array(layers.standard)
				
				var layer = layers.options.pick_random()
				unit.set_armor_thickness(layer)
				layers.options.erase(layer)
