extends CharacterBody2D

signal projectile_shot(projectile_velocity: Vector2, projectile_vector: Vector2, projectile_damage : float)

@export var acceleration : float = 600
@export var max_speed : float = 125
@export var friction : float = 600
@export var weapons : Array[WeaponData]
@export var current_weapon_iter : int = 0

@onready var animation_tree = $CharacterAnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

var is_shooting : bool = false
var can_shoot : bool = true
var facing_direction : Vector2


func _update_weapon_sprite():
	var current_weapon : WeaponData = get_current_weapon()
	$WeaponStackedSprite2D.texture = current_weapon.sprite_stack
	$WeaponStackedSprite2D.hframes = current_weapon.sprite_stack_layers
	$WeaponText2D/Label.text = current_weapon.name
	$WeaponText2D/AnimationPlayer.play("FadeOut")

func cycle_next():
	current_weapon_iter += 1
	if current_weapon_iter >= weapons.size():
		current_weapon_iter = 0
	_update_weapon_sprite()

func cycle_prev():
	current_weapon_iter -= 1
	if current_weapon_iter < 0:
		current_weapon_iter = weapons.size() - 1
	_update_weapon_sprite()

func get_current_weapon():
	if weapons.size() == 0:
		return
	if current_weapon_iter >= weapons.size():
		current_weapon_iter = 0
	return weapons[current_weapon_iter]

func face_direction(new_direction : Vector2):
	facing_direction = new_direction.normalized()
	animation_tree.set("parameters/Idle/blend_position", facing_direction)
	$BodyStackedSprite2D.sprite_rotation = facing_direction.angle()
	var current_weapon : WeaponData = get_current_weapon()
	$WeaponStackedSprite2D.position = $BodyStackedSprite2D.position + (facing_direction * current_weapon.weapon_offset)
	$WeaponStackedSprite2D.sprite_rotation = facing_direction.angle()

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

func shoot():
	if is_shooting and can_shoot:
		var current_weapon : WeaponData = get_current_weapon()
		var projectile_vector = facing_direction * current_weapon.projectile_speed
		var projectile_offset = facing_direction * (current_weapon.weapon_offset + current_weapon.barrel_offset)
		emit_signal("projectile_shot", projectile_vector, projectile_offset, current_weapon.damage)
		can_shoot = false
		$CooldownTimer.start(current_weapon.cooldown)

func _physics_process(delta):
	move_state(delta)
	shoot()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var current_window = get_window()
		var mouse_position = event.position - Vector2(current_window.content_scale_size / 2) 
		face_direction(mouse_position)

func _on_cooldown_timer_timeout():
	can_shoot = true
