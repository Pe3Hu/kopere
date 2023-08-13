extends MarginContainer


@onready var bg = $BG
@onready var armor = $HBox/Armor
@onready var apparatus = $HBox/Apparatus
@onready var icon = $HBox/Icon

var unit = null
var reel = null


func _ready():
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	update_size()


func update_size() -> void:
	var vector = Vector2(Global.vec.size.cell)
	custom_minimum_size = vector


func set_unit(unit_: MarginContainer) -> void:
	unit = unit_
	icon.label.text = str(unit.index)
	set_armor()
	set_apparatus()


func set_armor() -> void:
	armor.pb.max_value = unit.armor.pb.max_value
	armor.pb.value = unit.armor.pb.max_value
	armor.label.text = str(unit.armor.pb.max_value)
	armor.update_color()


func set_apparatus() -> void:
	apparatus.pb.max_value = unit.apparatus.pb.max_value
	apparatus.pb.value = unit.apparatus.pb.max_value
	apparatus.label.text = str(unit.apparatus.pb.max_value)
	apparatus.update_color()
	
 
