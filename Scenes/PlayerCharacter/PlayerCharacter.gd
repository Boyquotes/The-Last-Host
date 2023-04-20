extends CharacterBody2D

signal projectile_shot(projectile_scene : PackedScene, projectile_position: Vector2, projectile_velocity: Vector2, projectile_damage : float)
signal casing_dropped(casing_scene : PackedScene, casing_position : Vector2)
signal dash(cooldown : float)

@export var acceleration : float = 600
@export var max_speed : float = 125
@export var friction : float = 600
@export var dash_speed : float = 400
@export var weapons : Array[WeaponData]
@export var current_weapon_iter : int = 0

@onready var animation_tree = $CharacterAnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

var is_shooting : bool = false
var can_shoot : bool = true
var facing_direction : Vector2
var is_dashing : bool = false
var can_dash : bool = true

func _update_weapon_sprite():
	var current_weapon : WeaponData = get_current_weapon()
	$WeaponStackedSprite2D.y_offset = current_weapon.y_offset
	$WeaponStackedSprite2D.hframes = current_weapon.sprite_stack_layers
	$WeaponStackedSprite2D.texture = current_weapon.sprite_stack
	$WeaponText2D/Label.text = current_weapon.name
	$WeaponText2D/AnimationPlayer.play("FadeOut")
	face_direction(facing_direction)

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
		if is_dashing and can_dash:
			velocity = input_vector * dash_speed
			can_dash = false
			$DashTimer.start()
			emit_signal("dash", $DashTimer.wait_time)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move()

func move():
	move_and_slide()

func shoot():
	if is_shooting and can_shoot:
		var current_weapon : WeaponData = get_current_weapon()
		var projectile_vector = facing_direction * current_weapon.projectile_speed
		var casing_position = position + (facing_direction * current_weapon.weapon_offset)
		$WeaponShot.shoot(current_weapon.shots)
		can_shoot = false
		$CooldownTimer.start(current_weapon.cooldown)
		await get_tree().create_timer(0.0167).timeout
		emit_signal("casing_dropped", current_weapon.casing_scene, casing_position)

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

func _on_dash_timer_timeout():
	can_dash = true

func _on_weapon_shot_projectile_shot(projectile_scene, angle_offset):
	var current_weapon : WeaponData = get_current_weapon()
	var projectile_vector = (facing_direction * current_weapon.projectile_speed).rotated(angle_offset)
	var projectile_position = position + (facing_direction * (current_weapon.weapon_offset + current_weapon.barrel_offset))
	emit_signal("projectile_shot", projectile_scene, projectile_position, projectile_vector, current_weapon.damage)
