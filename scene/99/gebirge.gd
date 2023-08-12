extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_size()


func update_size() -> void:
	var x = Global.num.size.felssturz.col*Global.num.size.stein.r*2
	var y = (Global.num.size.felssturz.row+1.0/3)*Global.num.size.stein.R*1.5
	custom_minimum_size = Vector2(x,y)
