extends RigidBodyProjectile

signal spawned_projectile(projectile_scene : PackedScene, projectile_position : Vector2, projectile_velocity : Vector2, team : TeamConstants.Teams, damage : float)

@export var explosion_scene : PackedScene

func _detonate():
	emit_signal("spawned_projectile", explosion_scene, position, Vector2.ZERO, team, damage)
	queue_free()

func _on_projectile_expired():
	_detonate()

func _on_new_body_collided(opponent_node : Node2D):
	_detonate()

func _activate_collision_mask(layer):
	super._activate_collision_mask(layer)
	$Area2D.set_collision_mask_value(layer, true)

func _on_area_2d_body_entered(body):
	_on_body_collided(body)
