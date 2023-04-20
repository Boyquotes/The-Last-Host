extends BaseGameProjectile

func _on_projectile_expired():
	queue_free()

func _on_new_body_collided(opponent_node : Node2D):
	if opponent_node.has_method("hit"):
		opponent_node.hit(damage)
