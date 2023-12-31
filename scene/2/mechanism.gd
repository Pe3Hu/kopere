extends MarginContainer


@onready var label = $Label
@onready var icons = $Icons
@onready var weapons = $Weapons

var firehill = null
var milestone = null
var ifm = null#$Icons/IndexForMilestone
var target = null#$Icons/IndexForMilestone

var team = null
var remoteness = 0
var speed =  10
var active_weapon = null
var aim = null
var active = true


func _ready() -> void:
	label.text = str(Global.num.index.mechanism)
	Global.num.index.mechanism += 1
	ifm = Global.scene.icon.instantiate()
	icons.add_child(ifm)
	ifm.label.text = label.text
	target = Global.scene.target.instantiate()
	icons.add_child(target)
	target.mechanism = self
	equip_weapon("pistol")#automatic rifle
	select_aim()


func equip_weapon(title_: String) -> void:
	var weapon = Global.scene.weapon.instantiate()
	weapon.init(title_)
	weapons.add_child(weapon)
	active_weapon = weapon
	weapon.mechanism = self


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
		if foe.target.get_parent() == foe.icons:
			foe.icons.remove_child(foe.target)
			firehill.targets.add_child(foe.target)
		
		var hex = get_hex_by_aim(foe.target, aim)
		var scatter = active_weapon.get_scatter()
		var salvo = active_weapon.get_salvo()
		var goals = get_all_hexs_around_aim(hex, scatter)
		add_misses(goals, scatter)
		aim_at_markers(goals)
		var reel = Global.scene.reel.instantiate()
		reel.init(salvo)
		firehill.reels.add_child(reel)
		reel.mechanism = self
		reel.add_goals(goals)
		reel.skip_animation()
		Global.num.index.shot += 1
		#reel.timer.start()


func select_foe() -> Variant:
	var foe = null
	var opponent = Global.dict.team.opponent[team]
	var foes = firehill.teams[opponent]
	
	if !foes.is_empty():
		foe = foes.front()
		
		if !foe.active:
		#if foe.target.integrity.pb.value <= 0:
			foe = null
	
	return foe


func select_aim() -> void:
	aim = "elimination"


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
		"elimination":
			var hexs = target_.vulnerabilities
			
			if !hexs.is_empty():
				hex = hexs.pick_random()
			else:
				ring = 0
	
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


func add_misses(goals_: Array, scatter_: int) -> void:
	var scope = Global.dict.scope.scatter[scatter_]
	
	while scope > goals_.size():
		goals_.append(null)


func aim_at_markers(goals_: Array) -> void:
	var markers = []
	var repeats = 2
	
	for goal in goals_:
		if goal != null:
			if goal.unit.marker:
				markers.append(goal)
	
	for goal in markers:
		for _i in repeats:
			goals_.append(goal)


func disrupt() -> void:
	if active:
		active = false
		#print(Global.num.index.shot)
	
		if Global.num.index.weapon < Global.dict.weapon.title.keys().size():
			statistics_collection()

			if Global.num.index.iteration == 10:
				Global.num.index.weapon += 1
				Global.num.index.iteration = 0

				if Global.num.index.weapon < Global.dict.weapon.title.keys().size():
					var weapon = Global.dict.weapon.title.keys()[Global.num.index.weapon]
					equip_weapon(weapon)

			target.reset()
		else:
			Global.save_statistics(self)



func statistics_collection() -> void:
	if !Global.stats.weapon.has(active_weapon.title):
		Global.stats.weapon[active_weapon.title] = []
	
	Global.stats.weapon[active_weapon.title].append(int(Global.num.index.shot))
	Global.num.index.shot = 0
	Global.num.index.iteration += 1
