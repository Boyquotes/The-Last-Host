extends Control

@onready var base_world_node = $SubViewportContainer/SubViewport/BaseWorld

var crosshair_scene = preload("res://Assets/Sourced/Icons/crosshair.png")

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(crosshair_scene, Input.CURSOR_ARROW, Vector2(16, 16))

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
	
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
		elif event.is_action("cycle_next"):
			base_world_node.set_pc_cycle_next()
		elif event.is_action("cycle_prev"):
			base_world_node.set_pc_cycle_prev()
			
