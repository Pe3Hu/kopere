extends Polygon2D


@onready var label = $Label
@onready var unit = $Unit

var target = null
var index = null
var ring = null
var grid = null
var neighbors = {}


func init(target_: MarginContainer) -> void:
	target = target_
	set_vertexs()


func set_vertexs() -> void:
	var order = "odd"
	var corners = 6
	var r = Global.num.size.unit.R
	var vertexs = []
	
	for corner in corners:
		var a = Global.dict.corner.vector
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func update_color() -> void:
	var step = 4
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = (180 + unit.thickness * step) / max_h
	var color_ = Color.from_hsv(h,s,v)
	set_color(color_)
 

func set_index(index_: int) -> void:
	index = index_
	unit.icon.label.text = str(index)


func clean() -> void:
	for neighbor in neighbors:
		neighbor.neighbors.erase(self)
	
	for grid in target.grids:
		if target.grids[grid] == self:
			target.grids.erase(grid)
			break
	
	for hexs in target.rings:
		if hexs.has(self):
			hexs.erase(self)
			break
	
	get_parent().remove_child(self)
	queue_free()
