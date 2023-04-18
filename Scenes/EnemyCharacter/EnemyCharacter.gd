extends CharacterBody2D

signal damage_taken(current_position : Vector2, damage_amount : float)

@export var movement_speed = 10

var player_node : CharacterBody2D


func _physics_process(delta):
	if not player_node:
		player_node = get_tree().get_first_node_in_group("player")
		return
	
	velocity = position.direction_to(player_node.position) * movement_speed
	move_and_slide()

func hit(damage_amount):
	$AnimationPlayer.play("HitFlash")
	emit_signal("damage_taken", position, damage_amount)
