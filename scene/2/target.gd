extends Control


@onready var rings = $Rings


func _ready() -> void:
	init_cells()


func init_cells() -> void:
	var lengths = []
	var index = 0
	var n = 6
	var layers = {}
	layers.standard = [4,4,4,5,5]
	layers.options = []
	
	for _i in 5:
		var length = _i * n
		lengths.append(length)
	
	lengths[0] = 1
	
	for _i in lengths.size():
		var length = lengths[_i]
		var ring = GridContainer.new()
		ring.columns = n
		#ring.set_alignment(1)
		ring.name = str(_i)
		rings.add_child(ring)
		
		for _j in length:
			var cell = Global.scene.cell.instantiate()
			ring.add_child(cell)
			cell.set_index(_i)
			index += 1
		
		for _j in _i:
			var cell = ring.get_child(_j)
			cell.set_armor_thickness(3)
		
		if _i == 0:
			var cell = ring.get_child(0)
			cell.set_armor_thickness(3)
		
		for cell in ring.get_children():
			if cell.armor.label.text == "":
				if layers.options.is_empty():
					layers.options.append_array(layers.standard)
				
				var layer = layers.options.pick_random()
				cell.set_armor_thickness(layer)
				layers.options.erase(layer)
	

