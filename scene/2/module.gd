extends MarginContainer


@onready var units = $Units

var factory = null
var borders = null
var index_reserve = 0


func _ready() -> void:
	update_size()
	init_units()


func update_size() -> void:
	borders = Vector2(Global.num.size.module.col, Global.num.size.module.row)
	var x = (Global.num.size.module.col + 0.5)* Global.num.size.unit.r * 2
	var y = (Global.num.size.module.row + 1.0/3) * Global.num.size.unit.R * 1.5
	custom_minimum_size = Vector2(x,y)


func init_units() -> void:
	index_reserve += Global.num.index.unit
	
	for _i in Global.num.size.module.row:
		for _j in Global.num.size.module.col:
			var unit = Global.scene.unit.instantiate()
			units.add_child(unit)
			unit.module = self
			unit.index = Global.num.index.unit
			Global.num.index.unit += 1
			unit.set_grid(Vector2(_j,_i))
			unit.visible = false
	
	init_unit_neighbors()
	init_around_center()
	init_unit_rotates()


func init_unit_neighbors() -> void:
	for unit in units.get_children():
		for direction in Global.dict.neighbor.hex[unit.parity]:
			var grid = unit.grid + direction

			if Global.check_array_has_grid(self, grid):
				var neighbor = get_unit_by_grid(grid)
				unit.neighbors[neighbor] = direction


func get_unit_by_grid(grid_: Vector2) -> Polygon2D:
	var index = grid_.y * Global.num.size.module.col + grid_.x
	return units.get_child(index)


func init_around_center() -> void:
	var center_grid = Vector2(Global.num.size.module.col/2, Global.num.size.module.row/2)
	var center_unit = get_unit_by_grid(center_grid)
	var ring = Global.num.size.module.col/2
	var arounds = get_units_around_unit(center_unit, ring)
	
	for arounds_ in arounds:
		for unit_ in arounds_:
			unit_.visible = true


func get_units_around_unit(unit_, rings_) -> Array:
	var arounds = [[unit_]]
	var totals = [unit_]
	
	for _i in rings_:
		var next_ring = []
		
		for _j in range(arounds[_i].size()-1,-1,-1):
			for neighbor in arounds[_i][_j].neighbors.keys():
				if !totals.has(neighbor):
					next_ring.append(neighbor)
					totals.append(neighbor)
		
		arounds.append(next_ring)
	
	return arounds


func init_unit_rotates() -> void:
	var n = Global.num.size.module.n
	var m = Global.num.size.module.n/2
	var rotates = ["clockwise", "counterclockwise"]
	var center_grid = Vector2(Global.num.size.module.col/2, Global.num.size.module.row/2)
	var center_unit = get_unit_by_grid(center_grid)
	
	for rotate in rotates:
		center_unit.rotates[rotate] = center_unit
	
	for _i in range(1, m, 1):
		var axises = []
		
		for _j in Global.dict.neighbor.hex[center_unit.parity].size():
			var axis_grid = center_grid + Vector2()
			
			for _l in _i:
				var axis_direction = Global.dict.neighbor.hex[int(axis_grid.y)%2][_j]
				axis_grid += axis_direction
			
			var axis_unit = get_unit_by_grid(center_grid)
			var units = [axis_unit]
			
			var shfit_grid = axis_grid + Vector2()
			var shift = (_j + 2) % n
			
			for _l in _i - 1:
				var shift_direction = Global.dict.neighbor.hex[int(shfit_grid.y)%2][shift]
				shfit_grid += shift_direction
				var shfit_unit = get_unit_by_grid(shfit_grid)
				units.append(shfit_unit)
			
			axises.append(units)
		
		for _j in axises.size():
			for _l in axises[_j].size():
				var unit = axises[_j][_l]
				
				for rotate in rotates:
					var shift = 0
					
					match rotate:
						"clockwise":
							shift = 1
						"counterclockwise":
							shift = 5
				
					shift = (_j + shift) % n
					unit.rotates[rotate] = axises[shift][_l]
	
	var grid = Vector2(1,0)
	var unit = get_unit_by_grid(grid)
	print(unit.rotates)

