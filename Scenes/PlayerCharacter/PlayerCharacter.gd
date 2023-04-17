extends CharacterBody2D


@export var acceleration = 600
@export var max_speed = 125
@export var friction = 600


@onready var animation_tree = $CharacterAnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func face_direction(new_direction : Vector2):
	animation_tree.set("parameters/Idle/blend_position", new_direction.normalized())
	$BodyStackedSprite2D.sprite_rotation = new_direction.angle()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move()

func move():
	move_and_slide()

func _physics_process(delta):
	move_state(delta)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var current_window = get_window()
		var mouse_position = event.position - Vector2(current_window.content_scale_size / 2) 
		face_direction(mouse_position)

