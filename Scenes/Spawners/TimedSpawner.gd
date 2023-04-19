@tool
extends Spawner

@export var time = 1.0


func _ready():
	if not Engine.is_editor_hint():
		$Timer.start(time)


func _on_timer_timeout():
	spawn()
