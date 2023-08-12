extends MarginContainer


@onready var milestones = $Milestones

var teams = {}
var max_remoteness = 0

func _ready() -> void:
	init_milestones()
	init_teams()


func init_milestones() -> void:
	var n = 10
	max_remoteness = (n - 1) * 10
	
	for _i in n:
		var milestone = Global.scene.milestone.instantiate()
		#ring.set_alignment(1)
		milestones.add_child(milestone)
		milestone.set_remoteness(_i)


func init_teams() -> void:
	for team in Global.arr.team:
		teams[team] = []
	
	var mechanism = add_mechanism()
	add_mechanism_to_team("attackers", mechanism)
	mechanism = add_mechanism()
	add_mechanism_to_team("attackers", mechanism)


func add_mechanism() -> MarginContainer:
	var mechanism = Global.scene.mechanism.instantiate()
	mechanism.remoteness = max_remoteness
	return mechanism


func add_mechanism_to_team(team_: String, mechanism_: MarginContainer) -> void:
	var remoteness = null
	
	match team_:
		"attackers":
			remoteness = 9
		"defenders":
			remoteness = 0
	
	teams[team_].append(mechanism_)
	mechanism_.firehill = self
	mechanism_.reach_milestone(str(remoteness))


func _on_timer_timeout():
	attackers_move()


func attackers_move() -> void:
	for mechanism in teams["attackers"]:
		mechanism.move()
