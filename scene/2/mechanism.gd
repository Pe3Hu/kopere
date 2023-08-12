extends MarginContainer


@onready var label = $Label

var firehill = null
var milestone = null
var remoteness = 0
var speed =  10


func _ready() -> void:
	label.text = str(Global.num.index.mechanism)
	Global.num.index.mechanism += 1


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
		milestone.mechanisms.remove_child(self)
	
	milestone = firehill.milestones.get_node(name_)
	milestone.mechanisms.add_child(self)
