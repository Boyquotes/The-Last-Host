@tool
extends Node2D
class_name Spawner

signal spawn_enemy(node)

@export var spawn_extents : Vector2 = Vector2.ONE : # number of pixels the enemy can spawn from the center of the spawner (rectangle)
	set(value):
		spawn_extents = value
		queue_redraw()
@export var enemy_scene : PackedScene # the enemy to spawn
@export var amount : int = -1 # how many should be spawned in total, -1 = no limit
@export var debug_draw = false # draw the spawn area


func _draw():
	if Engine.is_editor_hint() or debug_draw:
		draw_rect(Rect2(-spawn_extents, spawn_extents*2), Color(0.5, 0, 0.3, 0.5))


func spawn(_amount = 1):
	if Engine.is_editor_hint(): return # does not spawn enemies if in editor
	if amount > -1 and amount < _amount:
		_amount = amount
	
	for i in range(_amount):
		var spawn_point = Vector2(
			randf_range(position.x-spawn_extents.x, position.x + spawn_extents.x),
			randf_range(position.y-spawn_extents.y, position.y + spawn_extents.y)
			)
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_point
		emit_signal("spawn_enemy", enemy)
		if amount > 0:
			amount -= 1
	
	
