extends CharacterBody2D

var moving_speed = 10

var player_node : CharacterBody2D
var following = false


func _physics_process(delta):
	if not (following and player_node): return
	
	velocity = position.direction_to(player_node.position) * moving_speed
	move_and_slide()


func _on_player_detection_area_body_entered(body):
	if body == player_node:
		following = true


func _on_player_detection_area_body_exited(body):
	if body == player_node:
		following = false


func _on_picked_up_area_body_entered(body):
	if body == player_node:
		print("picked up")
		# the item get picked up by the player, queue_free(), sfx, etc should go there
