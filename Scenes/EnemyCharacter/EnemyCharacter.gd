extends CharacterBody2D

signal damage_taken(current_position : Vector2, damage_amount : float)

@export var max_health = 100
@export var movement_speed = 10

var player_node : CharacterBody2D
var health = max_health


func _physics_process(delta):
	if not player_node:
		player_node = get_tree().get_first_node_in_group("player")
		return
	
	velocity = position.direction_to(player_node.position) * movement_speed
	move_and_slide()

func hit(damage_amount):
	health -= damage_amount
	if health > 0:
		$AnimationPlayer.play("HitFlash")
	else:
		$AnimationPlayer.play("FadeOut")
	emit_signal("damage_taken", position, damage_amount)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FadeOut":
		queue_free()
