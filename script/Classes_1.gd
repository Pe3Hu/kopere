extends Node


#Камень stein
class Stein:
	var num = {}
	var vec = {}
	var dict = {}
	var flag = {}
	var obj = {}
	var scene = {}


	func _init(input_):
		vec.grid = input_.grid
		num.parity = int(vec.grid.y)%2
		num.index = Global.num.index.stein
		Global.num.index.stein += 1
		dict.neighbor = {}
		dict.rotate = {}
		obj.berggipfel = input_.berggipfel
		obj.felssturz = input_.felssturz
		flag.felsen = false
		flag.crack = false
		flag.on_screen = false
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.stein.instantiate()
		
		if obj.berggipfel != null:
			obj.berggipfel.scene.myself.get_node("Stein").add_child(scene.myself)
		
		if obj.felssturz != null:
			obj.felssturz.scene.myself.get_node("Stein").add_child(scene.myself)
			flag.on_screen = true
			
			if num.parity == 1 and vec.grid.x == Global.num.size.felssturz.col-1:
				flag.on_screen = false
		
		scene.myself.set_parent(self)


#Скала felsen
class Felsen:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_):
		num.index = Global.num.index.felsen
		Global.num.index.felsen += 1
		word.letter = input_.letter
		arr.index = input_.indexs
		obj.berggipfel = input_.berggipfel
		set_stein()
		#init_scene()


	func set_stein() -> void:
		arr.stein = []
		
		for index in arr.index:
			var stein = obj.berggipfel.get_stein_by_index(index)
			arr.stein.append(stein)


	func init_scene() -> void:
		scene.myself = Global.scene.felsen.instantiate()
		scene.myself.set_parent(self)


	func get_directions() -> Array:
		var steins = []
		steins.append_array(arr.stein)
		var childs = []
		var branches = []
		var branch = {}
		branch.direction_index = -1
		branch.parent = null
		branch.child = steins.front().scene.myself.get_node("Label").text
		branches.append(branch)
		childs.append(steins.pop_front())
		var parents = [branch.parent]
		
		while childs.size() > 0:
			var parent = childs.pop_front()
			
			for _i in range(steins.size()-1,-1,-1):
				var child = steins[_i]
				
				if parent.dict.neighbor.keys().has(child):
					branch = {}
					var direction_vector = parent.dict.neighbor[child]
					branch.direction_index = Global.dict.neighbor.hex[parent.num.parity].find(direction_vector)
					branch.parent = parent.scene.myself.get_node("Label").text
					branch.child = child.scene.myself.get_node("Label").text
					branches.append(branch)
					childs.append(child)
					steins.erase(child)
					
					if !parents.has(branch.parent):
						parents.append(branch.parent)
		
		var trunks = []
		
		for branch_ in branches:
			var root = false
			
			for trunk in trunks:
				if trunk.has(branch_.parent):
					root = true
					
					if trunk.back() == branch_.parent:
						trunk.append(branch_.child)
						break
					else:
						var new_trunk = []
						var turn = trunk.find(branch_.parent)
						
						for _i in turn+1:
							new_trunk.append(trunk[_i])
						
						new_trunk.append(branch_.child)
						trunks.append(new_trunk)
						break
			
			if !root:
				var trunk = [branch_.parent,branch_.child]
				trunks.append(trunk)
		
		var tree = []
		
		for trunk in trunks:
			var directions = []
			
			for _i in trunk.size()-1:
				var parent = trunk[_i]
				var child = trunk[_i+1]
				
				for branch_ in branches:
					if branch_.parent == parent and branch_.child == child:
						directions.append(branch_.direction_index)
						break
			
			directions.pop_front()
			tree.append(directions)
		
		return tree
