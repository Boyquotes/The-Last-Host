@tool
extends Spawner

@export var area_size = Vector2(20, 20) : 
	set(value):
		area_size = value
		$Area2D/CollisionShape2D.shape.size = area_size

func _on_area_2d_body_entered(body):
	if not Engine.is_editor_hint():
		spawn(max(0, amount))
