extends Area2D

@export var team : TeamConstants.Teams
@export var damage : float
var velocity : Vector2
var collided_bodies : Array = []

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

func _on_new_body_collided(body_node):
	if body_node.has_method("hit"):
		body_node.hit(damage)

func _on_body_collided(body_node):
	if body_node in collided_bodies:
		return
	collided_bodies.append(body_node)
	_on_new_body_collided(body_node)

func _on_body_entered(body):
	_on_body_collided(body)
