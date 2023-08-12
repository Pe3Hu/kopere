extends MarginContainer


@onready var pb = $ProgressBar
@onready var mechanisms = $VBox/Mechanism
@onready var remoteness = $VBox/Remoteness


func set_remoteness(remoteness_: int) -> void:
	name = str(remoteness_)
	remoteness.text = str(remoteness_)
