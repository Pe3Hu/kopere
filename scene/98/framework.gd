extends MarginContainer


@onready var units = $Units

var factory = null
var borders = null
var index_reserve = 0


func _ready() -> void:
	update_size()
	init_units()


func update_size() -> void:
	borders = Vector2(Global.num.size.framework.col, Global.num.size.framework.row)
	var x = (Global.num.size.framework.col + 0.5) * Global.num.size.unit.r * 2
	var y = (Global.num.size.framework.row + 1.0/3) * Global.num.size.unit.R * 1.5
	custom_minimum_size = Vector2(x,y)


func init_units() -> void:
	index_reserve += Global.num.index.unit
	
	for _i in Global.num.size.framework.row:
		for _j in Global.num.size.framework.col:
			var unit = Global.scene.unit.instantiate()
			units.add_child(unit)
			unit.framework = self
			unit.index = Global.num.index.unit
			Global.num.index.unit += 1
			unit.set_grid(Vector2(_j,_i))
	
	init_unit_neighbors()


func init_unit_neighbors() -> void:
	for unit in units.get_children():
		for direction in Global.dict.neighbor.hex[unit.parity]:
			var grid = unit.grid + direction

			if Global.check_array_has_grid(self, grid):
				var neighbor = get_unit_by_grid(grid)
				unit.neighbors[neighbor] = direction


func get_unit_by_grid(grid_: Vector2) -> Polygon2D:
	var index = grid_.y * Global.num.size.framework.col + grid_.x
	return units.get_child(index)
