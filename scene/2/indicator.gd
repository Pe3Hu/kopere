extends MarginContainer


@onready var pb = $ProgressBar
@onready var bg = $BG
@onready var label = $Label


func _ready():
	update_size()


func update_size() -> void:
	var vector = Vector2(Global.vec.size.letter3)
	custom_minimum_size = vector


func update_color() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = {}
	v["fill"] = 1.0
	v["background"] = 0.5
	var h = null
	
	match name:
		"Armor":
			h = 120.0 / max_h
		"Apparatus":
			h = 0.0 / max_h
	
	for key in v:
		var style = StyleBoxFlat.new()
		pb.set("theme_override_styles/" + key, style)
		var color = Color.from_hsv(h, s, v[key])
		style.set_bg_color(color)


func add_value(value_: int) -> void:
	pb.value += value_
	
	if pb.value > pb.max_value:
		pb.value = pb.max_value
	
	if pb.value < pb.min_value:
		pb.value = pb.min_value

