extends Sprite2D


@export var team : TeamConstants.Teams
@export var damage : float
var velocity : Vector2
var time_since_spawn : float = 0
var collided_bodies : Array = []

func _physics_process(delta):
	time_since_spawn += delta
	position += velocity * delta
	rotation += delta * 25 

func _ready():
	var layer : int
	match(team):
		TeamConstants.Teams.PLAYER:
			layer = TeamConstants.Layers.ENEMY
		TeamConstants.Teams.ENEMY:
			layer = TeamConstants.Layers.PLAYER
	$Area2D.set_collision_mask_value(layer, true)

func _on_kill_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body in collided_bodies:
		return
	collided_bodies.append(body)
	if body.has_method("hit"):
		body.hit(damage)
