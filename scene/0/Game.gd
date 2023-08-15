extends Node


func _ready() -> void:
	#Global.node.reel = Global.scene.reel.instantiate()
	#Global.node.game.get_node("Layer0").add_child(Global.node.reel)
	Global.node.firehill = Global.scene.firehill.instantiate()
	Global.node.game.get_node("Layer0").add_child(Global.node.firehill)
	#Global.node.target = Global.scene.target.instantiate()
	#Global.node.game.get_node("Layer0").add_child(Global.node.target)
	#datas.sort_custom(func(a, b): return a.value < b.value) 012
	
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					Global.obj.gebirge.obj.berggipfel.num.felsen -= 1
					Global.obj.gebirge.obj.berggipfel.draw_felsen()
			KEY_D:
				if event.is_pressed() && !event.is_echo():
					Global.obj.gebirge.obj.berggipfel.num.felsen += 1
					Global.obj.gebirge.obj.berggipfel.draw_felsen()


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
	#Global.node.reel.smooth_spin()
