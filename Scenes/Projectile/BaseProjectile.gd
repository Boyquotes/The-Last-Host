extends Area2D
class_name BaseGameProjectile

@export var team : TeamConstants.Teams
@export var damage : float
var velocity : Vector2
var time_since_spawn : float = 0
var collided_bodies : Array = []

func _physics_process(delta):
	time_since_spawn += delta
	position += velocity * delta
	rotation = velocity.angle()

func _activate_collision_mask(layer):
	set_collision_mask_value(layer, true)

func _set_mask_layers():
	var layer : int
	match(team):
		TeamConstants.Teams.PLAYER:
			layer = TeamConstants.Layers.ENEMY
		TeamConstants.Teams.ENEMY:
			layer = TeamConstants.Layers.PLAYER
	_activate_collision_mask(layer)

func _ready():
	_set_mask_layers()

func _on_projectile_expired():
	pass

func _on_kill_timer_timeout():
	_on_projectile_expired()

func _on_new_body_collided(_body_node):
	pass

func _on_body_collided(body_node):
	if body_node in collided_bodies:
		return
	collided_bodies.append(body_node)
	_on_new_body_collided(body_node)

func _on_body_entered(body):
	_on_body_collided(body)
