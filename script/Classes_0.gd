extends Node


#Горный пик berggipfel
class Berggipfel:
	var num = {}
	var arr = {}
	var dict = {}
	var obj = {}
	var scene = {}


	func _init(input_):
		obj.gebirge = input_.gebirge
		num.felsen = 0
		num.stein = {}
		num.stein.reserve = Global.num.index.stein
		init_scene()
		init_steins()
		init_felsen()
		draw_felsen()


	func init_scene() -> void:
		scene.myself = Global.scene.berggipfel.instantiate()
		scene.myself.set_parent(self)
		obj.gebirge.scene.myself.get_node("HBox").add_child(scene.myself)


	func init_steins() -> void:
		arr.stein = []
		
		for _i in Global.num.size.berggipfel.row:
			arr.stein.append([])
			
			for _j in Global.num.size.berggipfel.col:
				var input = {}
				input.grid = Vector2(_j,_i)
				input.berggipfel = self
				input.felssturz = null
				var stein = Classes_1.Stein.new(input)
				arr.stein[_i].append(stein)
		
		init_stein_neighbors()
		init_around_center()
		init_stein_rotates()


	func init_around_center() -> void:
		var center_grid = Vector2(Global.num.size.berggipfel.col/2,Global.num.size.berggipfel.row/2)
		var center_stein = arr.stein[center_grid.y][center_grid.x]
		var ring = Global.num.size.berggipfel.col/2
		var arounds = get_steins_around_stein(center_stein, ring)
		
		for arounds_ in arounds:
			for stein_ in arounds_:
				stein_.flag.on_screen = true
				stein_.scene.myself.visible = true


	func init_stein_neighbors() -> void:
		for steins in arr.stein:
			for stein in steins:
				for direction in Global.dict.neighbor.hex[stein.num.parity]:
					var grid = stein.vec.grid + direction
					
					if Global.check_array_has_grid(arr.stein, grid):
						var neighbor = arr.stein[grid.y][grid.x]
						stein.dict.neighbor[neighbor] = direction


	func init_stein_rotates() -> void:
		var n = Global.num.size.berggipfel.n
		var m = Global.num.size.berggipfel.n/2
		var rotates = ["clockwise","counterclockwise"]
		var center_grid = Vector2(Global.num.size.berggipfel.col/2,Global.num.size.berggipfel.row/2)
		var center_stein = arr.stein[center_grid.y][center_grid.x]
		
		
		for rotate in rotates:
			center_stein.dict.rotate[rotate] = center_stein
		
		for _i in range(1,m,1):
			var axises = []
			
			for _j in Global.dict.neighbor.hex[center_stein.num.parity].size():
				var axis_grid = center_grid+Vector2()
				
				for _l in _i:
					var axis_direction = Global.dict.neighbor.hex[int(axis_grid.y)%2][_j]
					axis_grid += axis_direction
				
				var axis_stein = arr.stein[axis_grid.y][axis_grid.x]
				var steins = [axis_stein]
				
				var shfit_grid = axis_grid+Vector2()
				var shift = (_j+2)%n
				
				for _l in _i-1:
					var shift_direction = Global.dict.neighbor.hex[int(shfit_grid.y)%2][shift]
					shfit_grid += shift_direction
					var shfit_stein = arr.stein[shfit_grid.y][shfit_grid.x]
					steins.append(shfit_stein)
				
				axises.append(steins)
			
			for _j in axises.size():
				for _l in axises[_j].size():
					var stein = axises[_j][_l]
					
					for rotate in rotates:
						var shift = 0
						
						match rotate:
							"clockwise":
								shift = 1
							"counterclockwise":
								shift = 5
					
						shift = (_j+shift)%n
						stein.dict.rotate[rotate] = axises[shift][_l]
		
		var grid = Vector2(1,0)
		var stein = arr.stein[grid.y][grid.x]


	func get_steins_around_stein(stein_, rings_) -> Array:
		var arounds = [[stein_]]
		var totals = [stein_]
		
		for _i in rings_:
			var next_ring = []
			
			for _j in range(arounds[_i].size()-1,-1,-1):
				for neighbor in arounds[_i][_j].dict.neighbor.keys():
					if !totals.has(neighbor):
						next_ring.append(neighbor)
						totals.append(neighbor)
			
			arounds.append(next_ring)
		
		return arounds


	func init_felsen() -> void:
		arr.felsen = []
		
		for letter in Global.dict.pentahex.keys():
			var input = {}
			input.indexs = []
			
			for index in Global.dict.pentahex[letter]:
				input.indexs.append(index+num.stein.reserve)
			
			input.letter = letter
			input.berggipfel = self
			var felsen = Classes_1.Felsen.new(input)
			arr.felsen.append(felsen)
		
		rotate_felsens()
		flip_felsens()
		pinch_felsens()
		reinit_felsen()


	func rotate_felsens() -> void:
		dict.pentahex = {}
		dict.pentahex.rotate = {}
		
		for felsen in arr.felsen:
			dict.pentahex.rotate[felsen.word.letter] = {}
			var hashes = []
			
			for _i in range(0,6,1):
				var indexs = []
				
				for stein in felsen.arr.stein:
					var clockwise = stein
					
					for _j in _i:
						clockwise = clockwise.dict.rotate["clockwise"]
					
					indexs.append(clockwise.num.index)
					
				indexs.sort()
				
				var hash = indexs.hash()
				
				if !hashes.has(hash):
					hashes.append(hash)
					dict.pentahex.rotate[felsen.word.letter][_i] = indexs


	func flip_felsens() -> void:
		dict.pentahex.flip = {}
		
		for letter in dict.pentahex.rotate.keys():
			dict.pentahex.flip[letter] = []
			
			for _i in dict.pentahex.rotate[letter].size():
				dict.pentahex.flip[letter].append(flip_indexs(dict.pentahex.rotate[letter][_i]))


	func pinch_felsens() -> void:
		dict.pentahex.letter = {}
		
		for letter in Global.dict.pentahex.keys():
			dict.pentahex.letter[letter] = []
		
		for letter in dict.pentahex.rotate.keys():
			var hashes = []
			
			for _i in dict.pentahex.rotate[letter].size():
				var indexs = dict.pentahex.rotate[letter][_i]
				var pinched = [indexs]
				
				while pinched.back().size() != 0:
					var indexs_ = pinched.back()
					pinched.append(pinch_indexs(indexs_))
				
				if pinched.back().size() != 1:
					pinched.pop_back()
					indexs = pinched.back()
				
				indexs.sort()
				dict.pentahex.letter[letter].append(indexs)
				var hash = indexs.hash()
				hashes.append(hash)
			
			for _i in dict.pentahex.flip[letter].size():
				var indexs = dict.pentahex.flip[letter][_i]
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
					dict.pentahex.letter[letter].append(indexs)


	func reinit_felsen() -> void:
		arr.felsen = []
		Global.num.index.felsen = 0
		
		for letter in dict.pentahex.letter.keys():
			for indexs in dict.pentahex.letter[letter]:
				var input = {}
				input.indexs = indexs
				input.letter = letter
				input.berggipfel = self
				var felsen = Classes_1.Felsen.new(input)
				arr.felsen.append(felsen)


	func flip_indexs(indexs_: Array) -> Array:
		var indexs = []
		var shift = Global.num.size.berggipfel.col*2
		
		for index in indexs_:
			var original_stein = get_stein_by_index(index)
			var y = original_stein.vec.grid.y-Global.num.size.berggipfel.row/2
			var index_ = index-y*shift
			indexs.append(index_)
		
		return indexs


	func pinch_indexs(indexs_: Array) -> Array:
		var indexs = []
		var directions = [0,4,5]
		var opportunity = {}
		
		for direction in directions:
			opportunity[direction] = []
		
		for index in indexs_:
			var stein = get_stein_by_index(index)
		
			for direction in directions:
				var neighbor_grid = stein.vec.grid+Global.dict.neighbor.hex[stein.num.parity][direction]
				
				if Global.check_grid_on_screen(arr.stein, neighbor_grid):
					var index_ = arr.stein[neighbor_grid.y][neighbor_grid.x].num.index
					opportunity[direction].append(index_)
		
		for direction in directions:
			if opportunity[direction].size() != indexs_.size():
				opportunity.erase(direction)
		
		if opportunity.keys().size() > 0:
			indexs = opportunity[opportunity.keys().front()]
		
		return indexs


	func draw_felsen() -> void:
		num.felsen = (arr.felsen.size()+num.felsen)%arr.felsen.size()
		var felsen = arr.felsen[num.felsen]
		obj.gebirge.obj.felssturz.get_available_steins_for_felsen(felsen)
		
		for steins in arr.stein:
			for stein in steins:
				stein.flag.felsen = false
				stein.scene.myself.update_color()
		
		for index in felsen.arr.index:
			var stein = get_stein_by_index(index)
			stein.flag.felsen = true
			stein.scene.myself.update_color()


	func get_stein_by_index(index_: int) -> Classes_1.Stein:
		var index = index_-num.stein.reserve
		var x = index%Global.num.size.berggipfel.col
		var y = index/Global.num.size.berggipfel.col
		var stein = arr.stein[y][x]
		
		return stein



#Камнепад felssturz
class Felssturz:
	var num = {}
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_):
		num.stein = {}
		num.stein.reserve = Global.num.index.stein
		obj.gebirge = input_.gebirge
		init_scene()
		init_steins()


	func init_scene() -> void:
		scene.myself = Global.scene.felssturz.instantiate()
		scene.myself.set_parent(self)
		obj.gebirge.scene.myself.get_node("HBox").add_child(scene.myself)


	func init_steins() -> void:
		arr.stein = []
		
		for _i in Global.num.size.felssturz.row:
			arr.stein.append([])
			
			for _j in Global.num.size.felssturz.col:
				var input = {}
				input.grid = Vector2(_j,_i)
				input.berggipfel = null
				input.felssturz = self
				var stein = Classes_1.Stein.new(input)
				arr.stein[_i].append(stein)
		
		init_stein_neighbors()


	func init_stein_neighbors() -> void:
		for steins in arr.stein:
			for stein in steins:
				for direction in Global.dict.neighbor.hex[stein.num.parity]:
					var grid = stein.vec.grid + direction
					
					if Global.check_array_has_grid(arr.stein, grid):
						var neighbor = arr.stein[grid.y][grid.x]
						stein.dict.neighbor[neighbor] = direction


	func get_available_steins_for_felsen(felsen_: Classes_1.Felsen) -> void:
		var directions = felsen_.get_directions()
		var cols = {}
		arr.crack = []
		
		for row in Global.num.size.berggipfel.row:
			for stein in arr.stein[row]:
				var flag = true
				
				for branch in directions:
					if flag:
						var grid = stein.vec.grid
						
						for direction in branch:
							if flag:
								grid += Global.dict.neighbor.hex[int(grid.y)%2][direction]
								flag = flag and Global.check_grid_on_screen(arr.stein, grid)
							else:
								break
					else:
						break
				
				if flag:
					if !cols.keys().has(int(stein.vec.grid.x)):
						cols[int(stein.vec.grid.x)] = [int(stein.vec.grid.y)]
					else:
						cols[int(stein.vec.grid.x)].append(int(stein.vec.grid.y))
		
		for x in cols.keys():
			cols[x].sort()
			var y = cols[x].front()
			
			var stein = arr.stein[y][x]
			arr.crack.append(stein)
		
		for steins in arr.stein:
			for stein in steins:
				stein.flag.crack = false
				stein.scene.myself.update_color()
		
		for stein in arr.crack:
			stein.flag.crack = true
			stein.scene.myself.update_color()


#Горы gebirge
class Gebirge:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init():
		init_scene()
		init_felssturz()
		init_berggipfel()


	func init_scene() -> void:
		scene.myself = Global.scene.gebirge.instantiate()
		scene.myself.set_parent(self)
		Global.node.game.get_node("Layer0").add_child(scene.myself)


	func init_felssturz() -> void:
		var input = {}
		input.gebirge = self
		obj.felssturz = Classes_0.Felssturz.new(input)


	func init_berggipfel() -> void:
		var input = {}
		input.gebirge = self
		obj.berggipfel = Classes_0.Berggipfel.new(input)
