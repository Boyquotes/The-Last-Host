extends Node2D

signal projectile_shot(projectile_scene : PackedScene, projectile_velocity: Vector2, projectile_damage : float)

@export var shots : Array[ShotData]

func _shoot_angled_shot(shot_data : ShotData, projectile_velocity: Vector2, projectile_damage : float):
	var angled_projectile_velocity = projectile_velocity.rotated(shot_data.angle_offset)
	emit_signal("projectile_shot", shot_data.projectile_scene, angled_projectile_velocity, projectile_damage)

func _shoot_single_shot(shot_data : ShotData, projectile_velocity: Vector2, projectile_damage : float):
	var timer_node
	if shot_data.time_offset > 0:
		timer_node = Timer.new()
		add_child(timer_node)
		timer_node.start(shot_data.time_offset)
		await timer_node.timeout
		timer_node.queue_free()
	_shoot_angled_shot(shot_data, projectile_velocity, projectile_damage)

func shoot(projectile_velocity: Vector2, projectile_damage : float):
	for shot_data in shots:
		_shoot_single_shot(shot_data, projectile_velocity, projectile_damage)
