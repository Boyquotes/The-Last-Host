extends RigidBodyProjectile

func _detonate():
	queue_free()

func _on_projectile_expired():
	_detonate()

func _on_new_body_collided(opponent_node : Node2D):
	_detonate()
