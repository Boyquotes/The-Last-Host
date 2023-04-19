# this spawner should replace all the others as it can act as each of them depending on which child node(s) you add to it
# add a timer and it will spawn enemies at each timeout
# add an area2D and it will spawn <ammount> of enemies when the player enter the area
# add both and it will start spawning enemies at each timeout after the player entered the area

@tool
extends Node2D

signal spawn_enemy(node)

@export var spawn_extents : Vector2 = Vector2.ONE : # number of pixels the enemy can spawn from the center of the spawner (rectangle)
	set(value):
		spawn_extents = value
		queue_redraw()
@export var enemy_scene : PackedScene # the enemy to spawn
@export var amount : int = -1 # how many should be spawned in total, -1 = no limit
@export var debug_draw = false # draw the spawn area

# see ready function
var timer : Timer # the timer child node (if any)
var area : Area2D # the area2D child node (if any)

func _draw():
	if Engine.is_editor_hint() or debug_draw:
		draw_rect(Rect2(-spawn_extents, spawn_extents*2), Color(0.5, 0, 0.3, 0.5))


func _ready():
	if Engine.is_editor_hint(): return
	
	# check if a timer and/or area2d have been attached to this node
	for child in get_children():
		if child is Timer:
			timer = child
			timer.timeout.connect(_on_timer_timeout)
		elif child is Area2D:
			area = child
			area.body_entered.connect(_on_area_body_entered)
	
	if timer and not area: # start the timer if no area, else the timer will start when player enter the area
		timer.start()


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


func _on_timer_timeout():
	spawn()


func _on_area_body_entered(_body):
	if not Engine.is_editor_hint():
		if timer:
			timer.start()
		else:
			spawn(amount)
