extends MarginContainer


@onready var bg = $BG
@onready var armor = $HBox/Armor
@onready var apparatus = $HBox/Apparatus
@onready var label = $HBox/Label

var index = null
var reel = null
var vulnerable = false


func _ready():
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	armor.update_color()
	apparatus.update_color()


func update_color(n_: int) -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = float(index)  / n_
	var color_ = Color.from_hsv(h,s,v)
	var style = bg.get("theme_override_styles/panel")
	style.set_bg_color(color_)


func set_index(index_: int) -> void:
	index = index_
	label.text = str(index)
	update_color(7)


func set_armor_thickness(layers_: int) -> void:
	var thickness = 5 * layers_
	armor.pb.max_value = thickness
	armor.pb.value = thickness
	armor.label.text = str(thickness)
	set_apparatus(100)


func set_apparatus(max_: int) -> void:
	apparatus.pb.max_value = max_
	apparatus.pb.value = max_
	apparatus.label.text = str(max_)
	
 
