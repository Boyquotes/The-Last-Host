extends Sprite2D


var velocity : Vector2
var time_since_spawn : float = 0

func _physics_process(delta):
	time_since_spawn += delta
	position += velocity * delta
	rotation += delta * 25 
