@tool
extends Spawner

@export var time = 1.0
@export var area_size = Vector2(20, 20) : 
	set(value):
		area_size = value
		$Area2D/CollisionShape2D.shape.size = area_size

func _ready():
	if not Engine.is_editor_hint():
		$Timer.wait_time = time

func _on_timer_timeout():
	spawn()


func _on_area_2d_body_entered(body):
	if not Engine.is_editor_hint():
		$Timer.start()
