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


func _ready() -> void:
	time = Time.get_unix_time_from_system()
	init_cells()
	reset()


func init_cells() -> void:
	var n = 7
	
	for _i in n:
		var cell = Global.scene.cell.instantiate()
		cells.add_child(cell)
		cell.set_index(_i)
	
	cells.position.y = -100


func reset() -> void:
	pace = 100
	tick = 0
	timer.start()
	
	for _i in cells.get_child_count():
		var cell = cells.get_child(_i)
		cell.set_index(_i)


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
		tween.tween_property(cells, "position", Vector2(0, -50), time)
		tween.tween_callback(pop_up)
		decelerate_spin()
#	else:
#		print("end at", Time.get_unix_time_from_system() - time)
#
#			var current_cell = cells.get_child(3)
#			#print(current_cell.index)
#			if !stats.has(current_cell.index):
#				stats[current_cell.index] = 0
#
#			stats[current_cell.index] += 1
#			counter += 1
#			reset()
#	else:
#		print(stats)



func pop_up() -> void:
	var cell = cells.get_child(cells.get_child_count() - 1)
	cells.move_child(cell, 0)
	cells.position.y += -50
	timer.start()
