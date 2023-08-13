extends Polygon2D


@onready var label = $Label

var unit = null


func _ready() -> void:
	set_vertexs()
	pass


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
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = null
	
	match unit.thickness:
		5:
			h = 0 / max_h
		10:
			h = 60 / max_h
		15:
			h = 120 / max_h
	
	var color_ = Color.from_hsv(h,s,v)
	set_color(color_)
