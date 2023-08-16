extends MarginContainer


var title = null
var mechanism = null
var projectile = null
var clip = {}
var victims = {} 


func init(title_: String)-> void:
	title = title_
	clip.max = Global.dict.weapon.title[title].clip
	equip_projectiles("marker")


func equip_projectiles(projectile_: String) -> void:
	#standard explosive splinter marker
	projectile = projectile_
	clip.current = int(clip.max)
	
	match projectile_:
		"splinter":
			victims[projectile_] = []
		"marker":
			victims[projectile_] = []


func get_penetration(vulnerable_: bool) -> int:
	return Global.dict.weapon.title[title].penetration["standard armor"]
	
	if vulnerable_:
		return Global.dict.weapon.title[title].penetration["critical armor"]
	else:
		return Global.dict.weapon.title[title].penetration["standard armor"]


func get_damage() -> int:
	var damage = Global.dict.weapon.title[title]["projectile damage"]
	return damage


func get_scatter() -> int:
	var scatter = Global.dict.weapon.title[title].scatter
	return scatter


func get_salvo() -> int:
	var salvo = Global.dict.weapon.title[title].salvo
	return salvo


func shoot(goal_: MarginContainer) -> void:
	clip.current -= 1
	
	if goal_.apparatus.pb.value > 0:
		if projectile == "marker":
			if goal_.vulnerable and !goal_.marker:
				goal_.marker = true
		
		var breach = false
		var limits = {}
		limits.penetration = get_penetration(goal_.vulnerable)
		limits.armor = goal_.armor.pb.value
		var damage = {}
		
		if limits.armor > 0:
			var roll = {}
			
			match projectile:
				"standard":
					limits.penetration += 0
				"explosive":
					limits.penetration -= 0
			
			for key in limits:
				Global.rng.randomize()
				roll[key] = Global.rng.randi_range(0, limits[key])
		
			damage.armor = roll.penetration - roll.armor
			#print([limits, roll])
			
			if roll.penetration > roll.armor:
				damage.armor = limits.penetration#roll.penetration
			else:
				damage.armor = roll.penetration#floor(sqrt(roll.penetration))
			
			goal_.armor.add_value(-damage.armor)
			
			if goal_.armor.pb.value <= 0:
				breach = true
		else:
			breach = true
		
		if breach:
			damage.apparatus = get_damage()
			goal_.apparatus.add_value(-damage.apparatus)
			
			match projectile:
				"explosive":
					damage.shard = floor(damage.apparatus / 6)
					
					for neighbor in goal_.hex.neighbors:
						neighbor.unit.apparatus.add_value(-damage.shard)
				"splinter":
					if !goal_.splinters.has(self):
						goal_.splinters[self] = 0
						victims[projectile].append(goal_)
					
					goal_.splinters[self] += 1
		
		mechanism.firehill.timer.start()
	else:
		through()
	
	reload()


func miss() -> void:
	mechanism.firehill.timer.start()


func through() -> void:
	mechanism.firehill.timer.start()


func reload() -> void:
	if clip.current == 0:
		clip.current = int(clip.max)
	
		match projectile:
			"splinter":
				for victim in victims[projectile]:
					for _i in victim.splinters[self]:
						var damage = 5
						
						var neighbor = victim.hex.neighbors.keys().pick_random()
						neighbor.unit.apparatus.add_value(-damage)
					
					victim.splinters.erase(self)
					victims[projectile].erase(victim)
