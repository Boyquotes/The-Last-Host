extends Control

@onready var base_world_node = $SubViewportContainer/SubViewport/BaseWorld

var crosshair_scene = preload("res://Assets/Sourced/Icons/crosshair.png")
var time = [0,0,0] # H,M,S
var can_cycle : bool = true

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(crosshair_scene, Input.CURSOR_ARROW, Vector2(16, 16))

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)

func _start_cycle_input_cooldown():
	can_cycle = false
	$CycleInputTimer.start()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var current_window = get_window()
		var mouse_position = event.position - Vector2(current_window.content_scale_size / 2) 
		base_world_node.set_pc_direction(mouse_position)
	elif event is InputEventMouseButton:
		if event.is_action_pressed("shoot"):
			base_world_node.set_pc_shooting(true)
		elif event.is_action_released("shoot"):
			base_world_node.set_pc_shooting(false)
		elif event.is_action_pressed("dash"):
			base_world_node.set_pc_dashing(true)
		elif event.is_action_released("dash"):
			base_world_node.set_pc_dashing(false)
		elif event.is_action("cycle_next"):
			if can_cycle:
				base_world_node.set_pc_cycle_next()
				_start_cycle_input_cooldown()
		elif event.is_action("cycle_prev"):
			if can_cycle:
				base_world_node.set_pc_cycle_prev()
				_start_cycle_input_cooldown()
			


func _on_base_world_player_dashed(cooldown):
	$DashCooldownIndicator.start(cooldown)


func _on_base_world_player_shoot(ammo_remaining):
	$AmmoCounter.current_ammo -= 1 # proto test until ammo count actually get handled in weapon/player


func _on_timer_timeout():
	time[2] += 1
	if time[2] >= 60:
		time[2] -= 60
		time[1]+=1
		if time[1] >= 60:
			time[1] -= 60
			time[0]+=1
	$LabelTime.text = "%02d:%02d:%02d" % time


func _on_cycle_input_timer_timeout():
	can_cycle = true
