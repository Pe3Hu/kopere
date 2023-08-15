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


func _ready() -> void:
	label.text = str(Global.num.index.mechanism)
	Global.num.index.mechanism += 1
	ifm = Global.scene.icon.instantiate()
	icons.add_child(ifm)
	ifm.label.text = label.text
	target = Global.scene.target.instantiate()
	icons.add_child(target)
	target.mechanism = self
	equip_weapon("pistol")


func equip_weapon(title_: String) -> void:
	var weapon = Global.scene.weapon.instantiate()
	weapon.init(title_)
	weapons.add_child(weapon)
	active_weapon = weapon


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
		foe.icons.remove_child(foe.target)
		firehill.targets.add_child(foe.target)
		var aim = select_aim()
		var hex = get_hex_by_aim(foe.target, aim)
		var scatter = 1
		var goals = get_all_hexs_around_aim(hex, scatter)
		add_misses(goals, scatter)
		var reel = Global.scene.reel.instantiate()
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
		
		if foe.target.integrity.pb.value <= 0:
			foe = null
	
	return foe


func select_aim() -> Variant:
	var aim = "elimination"
	
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


func shoot(goal_: MarginContainer) -> void:
	if goal_.apparatus.pb.value > 0:
		var breach = false
		var limits = {}
		limits.penetration = active_weapon.get_penetration(goal_.vulnerable)
		limits.armor = goal_.armor.pb.value
		var damage = {}
		
		if limits.armor > 0:
			var roll = {}
			
			match active_weapon.bullet:
				"standard":
					limits.penetration += 0
			
			for key in limits:
				Global.rng.randomize()
				roll[key] = Global.rng.randi_range(0, limits[key])
		
			damage.armor = roll.penetration - roll.armor
			#print([limits, roll])
			
			if roll.penetration > roll.armor:
				damage.armor = roll.penetration
			else:
				damage.armor = floor(sqrt(roll.penetration))
			
			goal_.armor.add_value(-damage.armor)
			
			if goal_.armor.pb.value <= 0:
				breach = true
		else:
			breach = true
		
		if breach:
			damage.apparatus = active_weapon.get_damage()
			goal_.apparatus.add_value(-damage.apparatus)
		
		firehill.timer.start()
	else:
		through()


func miss() -> void:
	firehill.timer.start()


func through() -> void:
	firehill.timer.start()


func disrupt() -> void:
	statistics_collection()
	
	if Global.num.index.iteration < 3:
		target.reset()
	else:
		print(Global.stats.weapon[active_weapon.title])



func statistics_collection() -> void:
	Global.stats.weapon[active_weapon.title][Global.num.index.iteration] = int(Global.num.index.shot)
	Global.num.index.shot = 0
	Global.num.index.iteration += 1
