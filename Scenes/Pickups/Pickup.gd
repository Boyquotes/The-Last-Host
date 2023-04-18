extends CharacterBody2D

var moving_speed = 10
var player_node : CharacterBody2D


func _physics_process(delta):
	if not player_node: return
	
	velocity = position.direction_to(player_node.position) * moving_speed
	move_and_slide()


func _on_player_detection_area_body_entered(body):
	player_node = body


func _on_player_detection_area_body_exited(body):
	player_node = null


func _on_picked_up_area_body_entered(body):
	print("picked up")
	# the item get picked up by the player, queue_free(), sfx, etc should go there
