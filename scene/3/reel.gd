extends Control


@onready var cells = $Cells
@onready var timer = $Timer
var tween = null

var index = 0
var pace = null
var tick = null
var time = null
var stats = {}
var counter = 0
var goals = []
var mechanism = null


func _ready() -> void:
	#time = Time.get_unix_time_from_system()
	#init_cells()
	pass


func add_goals(goals_: Array) -> void:
	goals.append_array(goals_)
	update_size()
	reset()


func update_size() -> void:
	var vector = Global.vec.size.unit + Vector2()
	vector.y *= 3
	custom_minimum_size = vector


func init_units() -> void:
	var n = 7
	
	for _i in n:
		var cell = Global.scene.cell.instantiate()
		cells.add_child(cell)
		cell.set_index(_i)
	
	reset()


func reset() -> void:
	shuffle_goals()
	pace = 100
	tick = 0
	#timer.start()
	cells.position.y = -Global.vec.size.unit.y * 2


func shuffle_goals() -> void:
	for cell in cells.get_children():
		cells.remove_child(cell)
		cell.queue_free()
	
	goals.shuffle()
	
	for hex in goals:
		var cell = Global.scene.cell.instantiate()
		cells.add_child(cell)
		cell.set_unit(hex.unit)


func decelerate_spin() -> void:
	tick += 1
	var limit = {}
	limit.min = 1.0
	limit.max = max(limit.min, 10.0 - tick * 0.05)
	#start 50 min 0.5 max 2.5 step 0.1 stop 4 = 10 sec
	#start 50 min 1.5 max 2.5 step 0.1 stop 4 = 5 sec
	#start 50 min 2.0 max 3.0 step 0.1 stop 4 = 4 sec
	#start 50 min 2.0 max 3.0 step 0.1 stop 10 = 2.5 sec
	#start 50 min 2.0 max 5.0 step 0.1 stop 10 = 2 sec
	#start 100 min 1.0 max 10.0 step 0.1 stop 10 = 2.2 sec
	Global.rng.randomize()
	var gap = Global.rng.randf_range(limit.min, limit.max)
	pace -= gap
	timer.wait_time = 1.0 / pace


func _on_timer_timeout():
	if pace >= 10:
		var time = 1.0 / pace
		tween = create_tween()
		tween.tween_property(cells, "position", Vector2(0, -Global.vec.size.unit.y), time)
		tween.tween_callback(pop_up)
		decelerate_spin()
	else:
		#print("end at", Time.get_unix_time_from_system() - time)
		var unit = cells.get_child(3).unit
		print(unit.hex.index)
		mechanism.shoot(unit)


func pop_up() -> void:
	var cell = cells.get_child(cells.get_child_count() - 1)
	cells.move_child(cell, 0)
	cells.position.y += -Global.vec.size.unit.y
	timer.start()


func get_goal_rnd() -> MarginContainer:
	var goal = goals.pick_random()
	
	return goal
