extends Polygon2D


var grid = null
var parity = null
var index = null
var neighbors = {}
var rotates = {}
var framework = null
var module = null


func set_grid(grid_: Vector2) -> void:
	grid = grid_
	var x = grid.x * Global.num.size.unit.r * 2
	var y = grid.y * Global.num.size.unit.R * 1.5
	parity = int(grid.y) % 2
	
	if parity == 1:
		x += Global.num.size.unit.r
	
	var offset_ = Vector2(Global.num.size.unit.r, Global.num.size.unit.R)
	position = Vector2(x,y)
	
	if module != null:
		position += offset_
	
	if framework != null:
		position.y += 1.0/6 * Global.num.size.unit.R
		
	set_vertexs()
	update_color()
	update_label()


func update_color() -> void:
	var max_h = 360.0
	var s = 0.25
	var v = 1
	var size = null
	
	if framework != null:
		size = Global.num.size.framework
		s = 1
	if module != null:
		size = Global.num.size.module
		s = 1
	
	var h = float(grid.y * size.row + grid.x) / (size.row * size.col)
	var color_ = Color.from_hsv(h,s,v)
	set_color(color_)


func set_vertexs() -> void:
	var order = "even"
	var corners = 6
	var r = Global.num.size.unit.R
	var vertexs = []
	
	for corner in corners:
		var a = Global.dict.corner.vector
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func update_label() -> void:
	var reserve = null
	var size = null
	
	if framework != null:
		reserve = framework.index_reserve
		size = Global.num.size.framework
	if module != null:
		reserve = module.index_reserve
		size = Global.num.size.module
	
	var index_ = index - reserve #size.col * grid.y + grid.x
	$Label.text = str(index_)
