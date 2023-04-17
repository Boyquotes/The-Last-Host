extends CharacterBody2D

@export var movement_speed = 10

var player_node : CharacterBody2D

func _physics_process(delta):
	if not player_node: return
	
	velocity = position.direction_to(player_node.position) * movement_speed
	move_and_slide()

