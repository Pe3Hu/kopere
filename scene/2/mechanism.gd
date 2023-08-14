extends MarginContainer


@onready var label = $Label
@onready var icons = $Icons

var firehill = null
var milestone = null
var ifm = null#$Icons/IndexForMilestone
var target = null#$Icons/IndexForMilestone

var team = null
var remoteness = 0
var speed =  10
var bullet = null


func _ready() -> void:
	label.text = str(Global.num.index.mechanism)
	Global.num.index.mechanism += 1
	ifm = Global.scene.icon.instantiate()
	icons.add_child(ifm)
	ifm.label.text = label.text
	target = Global.scene.target.instantiate()
	icons.add_child(target)


func move() -> void:
	if remoteness > 0:
		remoteness -= speed
		
		if remoteness < 0:
			remoteness = 0
		
		var name_ = str(remoteness/10)
		
		if milestone.name != name_:
			reach_milestone(name_)


func reach_milestone(name_: String) -> void:
	if milestone != null:
		milestone.mechanisms.remove_child(ifm)
	else:
		icons.remove_child(ifm)
	
	milestone = firehill.milestones.get_node(name_)
	milestone.mechanisms.add_child(ifm)


func prepare_shoot() -> void:
	var foe = select_foe()
	
	if foe != null:
		icons.remove_child(target)
		firehill.targets.add_child(target)
		bullet = select_bullet()
		var aim = select_aim()
		var hex = get_hex_by_aim(foe.target, aim)
		var scatter = 1
		#var goals = get_goals_by_hex(hex, scatter)
		var goals = get_all_hexs_around_aim(hex, scatter)
		var reel = Global.scene.reel.instantiate()
		firehill.reels.add_child(reel)
		reel.mechanism = self
		reel.add_goals(goals)
		reel.timer.start()


func shoot(goal_: MarginContainer) -> void:
	pass


func select_foe() -> Variant:
	var foe = null
	var opponent = Global.dict.team.opponent[team]
	var foes = firehill.teams[opponent]
	
	if !foes.is_empty():
		foe = foes.front()
	
	return foe


func select_bullet() -> Variant:
	var bullet = "standard"
	
	return bullet


func select_aim() -> Variant:
	var aim = "rapid-fire"
	
	return aim


func get_hex_by_aim(target_: Control, aim_: String) -> Variant:
	var hex = null
	var ring = null
	
	match aim_:
		"bullseye":
			ring = 0
		"rapid-fire":
			var grid = target_.grids.keys().pick_random()
			var rnd_hex = target_.grids[grid]
			ring = rnd_hex.ring
			
			
			ring = 1
	
	if ring != null:
		var hexs = target_.rings[ring]
		hex = hexs.pick_random()
	
	return hex


func get_all_hexs_around_aim(hex_: Polygon2D, scatter_: int) -> Variant:
	var goals = {}
	goals[hex_] = 0
	
	for _i in scatter_:
		for goal in goals:
			if goals[goal] == _i:
				for neighbor in goal.neighbors:
					if !goals.has(neighbor):
						goals[neighbor] = _i + 1
	
	return goals.keys()
	


func get_goals_by_hex(hex_: MarginContainer, scatter_: int) -> Variant:
	var goals = []
	var rings = [hex_.ring]
	
	if scatter_ == 1:
		if hex_.ring == 0:
			for _i in 6:
				rings.append(1)
		else:
			for _i in 3:
				var ring = hex_.ring + _i - 1
				
				for _j in _i + 1:
					rings.append(ring)
	
	print(rings)
	
	var options = {}
	
	for ring in rings:
		if !options.has(ring):
			options[ring] = []
			options[ring].append_array(hex_.target.rings.get_node(str(ring)).get_children())
	
		var goal = options[ring].pick_random()
		options[ring].erase(goal)
		goals.append(goal)
	
	return goals
