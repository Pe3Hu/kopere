extends MarginContainer


@onready var label = $Label


func _ready():
	update_size()


func update_size() -> void:
	var vector = Vector2(Global.vec.size.letter2)
	custom_minimum_size = vector
