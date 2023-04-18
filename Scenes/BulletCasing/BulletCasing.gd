extends Sprite2D


@export var initial_velocity  : Vector2 = Vector2(0, -5)
@export var height : float = 8
@export var rotation_mod : float = 5
@export var gravity : Vector2 = Vector2(0, 5)

@onready var velocity : Vector2 = initial_velocity
@onready var starting_y_position : float = position.y

func _physics_process(delta):
	velocity += gravity * delta
	if position.y >= starting_y_position + height:
		velocity = Vector2.ZERO
		rotation = PI/2
	else:
		position += velocity
		rotation += delta * rotation_mod

func _on_timer_timeout():
	queue_free()
