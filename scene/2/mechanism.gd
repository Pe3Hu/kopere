extends MarginContainer


@onready var label = $Label
@onready var target = $Target
@onready var icons = $Icons

var firehill = null
var milestone = null
var ifm = null#$Icons/IndexForMilestone

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
		bullet = select_bullet()
		var aim = select_aim()
		var unit = get_unit_by_aim(foe.target, aim)
		var scatter = 1
		var goals = get_goals_by_unit(unit, scatter)
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


func get_unit_by_aim(target_: Control, aim_: String) -> Variant:
	var unit = null
	var ring = null
	
	match aim_:
		"bullseye":
			ring = 0
		"rapid-fire":
			var rnd = target_.units.pick_random()
			ring = rnd.ring
			
			if ring == target_.rings.get_child_count():
				ring -= 1
			
			ring = 1
	
	if ring != null:
		var units = target_.rings.get_node(str(ring)).get_children()
		unit = units.pick_random()
	
	return unit


func get_goals_by_unit(unit_: MarginContainer, scatter_: int) -> Variant:
	var goals = []
	var rings = [unit_.ring]
	
	if scatter_ == 1:
		if unit_.ring == 0:
			for _i in 6:
				rings.append(1)
		else:
			for _i in 3:
				var ring = unit_.ring + _i - 1
				
				for _j in _i + 1:
					rings.append(ring)
	
	print(rings)
	
	var options = {}
	
	for ring in rings:
		if !options.has(ring):
			options[ring] = []
			options[ring].append_array(unit_.target.rings.get_node(str(ring)).get_children())
	
		var goal = options[ring].pick_random()
		options[ring].erase(goal)
		goals.append(goal)
	
	return goals
