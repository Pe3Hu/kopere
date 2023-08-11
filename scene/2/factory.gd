extends MarginContainer

@onready var hbox = $HBox
@onready var framework = $HBox/Framework
@onready var module = $HBox/Module
@onready var patterns = $HBox/Patterns

var pentahex = {}


func _ready() -> void:
	framework.factory = self
	module.factory = self
	hbox.move_child(module, 1)


func init_patterns() -> void:
	for letter in Global.dict.pentahex.indexs.keys():
		var pattern = Global.scene.pattern.instantiate()
		patterns.add_child(pattern)
		pattern.letter = letter
		pattern.module = module
		pattern.indexs.append_array(Global.dict.pentahex.indexs[letter])
		pattern.set_units()
		
#		for index in Global.dict.pentahex.indexs[letter]:
#			pattern.indexs.append(index + module.index_reserve)
	
	rotate_patterns()
	#flip_patterns()
	#pinch_patterns()
	#reinit_pattern()


func rotate_patterns() -> void:
	pentahex.rotates = {}
	
	for pattern in patterns.get_children():
		pentahex.rotates[pattern.letter] = {}
		var hashes = []
		
		for _i in range(0,6,1):
			var indexs = []
			
			for unit in pattern.units:
				var clockwise = unit
				
				for _j in _i:
					clockwise = clockwise.rotates["clockwise"]
				
				indexs.append(clockwise.index)
				
			indexs.sort()
			
			var hash = indexs.hash()
			
			if !hashes.has(hash):
				hashes.append(hash)
				pentahex.rotates[pattern.letter][_i] = indexs


func flip_patterns() -> void:
	pentahex.flip = {}
	
	for letter in pentahex.rotates.keys():
		pentahex.flip[letter] = []
		
		for _i in pentahex.rotates[letter].size():
			pentahex.flip[letter].append(flip_indexs(pentahex.rotates[letter][_i]))


func pinch_patterns() -> void:
	pentahex.letter = {}
	
	for letter in Global.dict.pentahex.indexs.keys():
		pentahex.letter[letter] = []
	
	for letter in pentahex.rotates.keys():
		var hashes = []
		
		for _i in pentahex.rotates[letter].size():
			var indexs = pentahex.rotates[letter][_i]
			var pinched = [indexs]
			
			while pinched.back().size() != 0:
				var indexs_ = pinched.back()
				pinched.append(pinch_indexs(indexs_))
			
			if pinched.back().size() != 1:
				pinched.pop_back()
				indexs = pinched.back()
			
			indexs.sort()
			pentahex.letter[letter].append(indexs)
			var hash = indexs.hash()
			hashes.append(hash)
		
		for _i in pentahex.flip[letter].size():
			var indexs = pentahex.flip[letter][_i]
			var pinched = [indexs]
			
			while pinched.back().size() != 0:
				var indexs_ = pinched.back()
				pinched.append(pinch_indexs(indexs_))
			
			if pinched.back().size() != 1:
				pinched.pop_back()
				indexs = pinched.back()
			
			indexs.sort()
			var hash = indexs.hash()
			hashes.append(hash)
			
			if !hashes.has(hash):
				pentahex.letter[letter].append(indexs)


func reinit_pattern() -> void:
	while patterns.get_child_count() > 0:
		var pattern = patterns.get_child(0)
		patterns.remove(pattern)
		pattern.queue_free()
	
	Global.num.index.pattern = 0
	
	for letter in pentahex.letter.keys():
		for indexs in pentahex.letter[letter]:
			var pattern = Global.scene.pattern.instantiate()
			patterns.add_child(pattern)
			pattern.indexs = indexs
			pattern.letter = letter
			pattern.module = module


func flip_indexs(indexs_: Array) -> Array:
	var indexs = []
	var shift = Global.num.size.module.col * 2
	
	for index in indexs_:
		var original_unit = module.units.get_child(index)
		var y = original_unit.grid.y - Global.num.size.module.row/2
		var index_ = index - y * shift
		indexs.append(index_)
	
	return indexs


func pinch_indexs(indexs_: Array) -> Array:
	var indexs = []
	var directions = [0,4,5]
	var opportunity = {}
	
	for direction in directions:
		opportunity[direction] = []
	
	for index in indexs_:
		var unit = module.units.get_child(index)
	
		for direction in directions:
			var neighbor_grid = unit.grid + Global.neighbor.hex[unit.num.parity][direction]
			
			if Global.check_grid_on_screen(module, neighbor_grid):
				var unit_ = module.get_unit_by_grid(neighbor_grid)
				opportunity[direction].append(unit_.num.index)
	
	for direction in directions:
		if opportunity[direction].size() != indexs_.size():
			opportunity.erase(direction)
	
	if opportunity.keys().size() > 0:
		indexs = opportunity[opportunity.keys().front()]
	
	return indexs

