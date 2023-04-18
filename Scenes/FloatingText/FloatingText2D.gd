extends Node2D

@export var velocity : Vector2 = Vector2(0, -1)
@export var text : String = "" : set = set_text

func set_text(new_text : String):
	text = new_text
	$Label.text = text

func _process(delta):
	position += delta * velocity
