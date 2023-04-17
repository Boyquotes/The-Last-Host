extends Control

var crosshair_scene = preload("res://Assets/Sourced/Icons/crosshair.png")

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(crosshair_scene)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
