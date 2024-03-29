extends Node2D
class_name BaseWorld

signal player_dashed(cooldown : float)
signal player_shoot(ammo_remaining)

@onready var pc_node = $CharacterContainer/PlayerCharacter
@onready var character_container = $CharacterContainer
@onready var projectile_container = $ProjectileContainer
@onready var rubbish_container = $RubbishContainer
@onready var collectible_container = $CollectibleContainer
@onready var text_container = $TextContainer
var muzzle_flash_scene = preload("res://Scenes/MuzzleFlash/MuzzleFlash.tscn")
var floating_text_scene = preload("res://Scenes/FloatingText/FloatingText2D.tscn")

func spawn_projectile(projectile_scene : PackedScene, projectile_position : Vector2, projectile_velocity : Vector2, team : TeamConstants.Teams, damage : float):
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.position = projectile_position
	projectile_instance.velocity = projectile_velocity
	projectile_instance.damage = damage
	projectile_instance.team = team
	if projectile_instance.has_signal("spawned_projectile"):
		projectile_instance.spawned_projectile.connect(spawn_projectile)
	projectile_container.call_deferred("add_child", projectile_instance)

func spawn_muzzle_flash(flash_position : Vector2):
	var muzzle_flash_instance = muzzle_flash_scene.instantiate()
	muzzle_flash_instance.position = flash_position
	projectile_container.add_child(muzzle_flash_instance)

func spawn_casing(casing_scene : PackedScene, casing_position : Vector2):
	var casing_instance = casing_scene.instantiate()
	casing_instance.position = casing_position
	rubbish_container.add_child(casing_instance)

func spawn_floating_text(text_position : Vector2, text_value : String):
	var floating_text_instance = floating_text_scene.instantiate()
	floating_text_instance.position = text_position
	floating_text_instance.text = text_value
	text_container.add_child(floating_text_instance)

func pc_shoots_projectile(projectile_scene : PackedScene, projectile_position : Vector2, projectile_velocity : Vector2, damage : float):
	spawn_projectile(projectile_scene, projectile_position, projectile_velocity, TeamConstants.Teams.PLAYER, damage)
	spawn_muzzle_flash(projectile_position)
	emit_signal("player_shoot", 0) # ammo not handled for now

func _on_player_character_projectile_shot(projectile_scene : PackedScene, projectile_position : Vector2, projectile_velocity : Vector2, damage : float):
	pc_shoots_projectile(projectile_scene, projectile_position, projectile_velocity, damage)

func _on_player_character_dash(cooldown):
	emit_signal("player_dashed", cooldown)
	
func _on_player_character_casing_dropped(casing_scene, casing_position):
	spawn_casing(casing_scene, casing_position)

func set_pc_shooting(shooting_flag : bool = true):
	pc_node.is_shooting = shooting_flag

func set_pc_direction(facing_direction : Vector2):
	pc_node.face_direction(facing_direction)

func set_pc_cycle_next():
	pc_node.cycle_next()

func set_pc_cycle_prev():
	pc_node.cycle_prev()

func set_pc_dashing(dashing_flag : bool):
	pc_node.is_dashing = dashing_flag

func _on_enemy_damage_taken(enemy_position : Vector2, damage : float):
	spawn_floating_text(enemy_position, str(damage))

func _on_spawner_spawn_enemy(node):
	if node.is_in_group(TeamConstants.ENEMY_GROUP) and node.has_signal("damage_taken"):
		node.damage_taken.connect(_on_enemy_damage_taken)
	character_container.call_deferred("add_child", node)

func _attach_enemy_signals():
	for child in character_container.get_children():
		if child.is_in_group(TeamConstants.ENEMY_GROUP):
			if child.has_signal("damage_taken"):
				child.damage_taken.connect(_on_enemy_damage_taken)

func _attach_spawners_signals():
	for child in $SpawnerContainer.get_children():
		child.spawn_enemy.connect(_on_spawner_spawn_enemy)

func _ready():
	_attach_enemy_signals()
	_attach_spawners_signals()


