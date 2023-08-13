extends MarginContainer


@onready var bg = $BG
@onready var armor = $HBox/Armor
@onready var apparatus = $HBox/Apparatus
@onready var icon = $HBox/Icon

var index = null
var target = null
var hex = null
var vulnerable = false
var ring = null
var grid = null
var neighbors = {}
var thickness = null


func _ready():
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	armor.update_color()
	apparatus.update_color()
	update_size()


func update_size() -> void:
	var vector = Global.vec.size.unit + Vector2()
	custom_minimum_size = vector


func update_color() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = float(index)  / 7
	var color_ = Color.from_hsv(h,s,v)
	color_ = Color.LIGHT_SLATE_GRAY
	var style = bg.get("theme_override_styles/panel")
	style.set_bg_color(color_)


func set_index(index_: int) -> void:
	index = index_
	icon.label.text = str(index)
	update_color()


func set_armor_thickness(layers_: int) -> void:
	thickness = 5 * layers_
	armor.pb.max_value = thickness
	armor.pb.value = thickness
	armor.label.text = str(thickness)
	set_apparatus(100)
	hex.update_color()


func set_apparatus(max_: int) -> void:
	apparatus.pb.max_value = max_
	apparatus.pb.value = max_
	apparatus.label.text = str(max_)


func switch_indicators() -> void:
	armor.visible = !armor.visible
	apparatus.visible = !apparatus.visible
 
