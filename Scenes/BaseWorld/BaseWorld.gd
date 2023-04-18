extends Node2D
class_name World

@onready var pc_node = $CharacterContainer/PlayerCharacter
@onready var character_container = $CharacterContainer
@onready var projectile_container = $ProjectileContainer
@onready var text_container = $TextContainer
var projectile_scene = preload("res://Scenes/Projectile/Projectile.tscn")
var muzzle_flash_scene = preload("res://Scenes/MuzzleFlash/MuzzleFlash.tscn")
var floating_text_scene = preload("res://Scenes/FloatingText/FloatingText2D.tscn")

func spawn_projectile(projectile_position : Vector2, projectile_velocity : Vector2, team : TeamConstants.Teams, damage : float):
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.position = projectile_position
	projectile_instance.velocity = projectile_velocity
	projectile_instance.damage = damage
	projectile_instance.team = team
	projectile_container.add_child(projectile_instance)

func spawn_muzzle_flash(flash_position : Vector2):
	var muzzle_flash_instance = muzzle_flash_scene.instantiate()
	muzzle_flash_instance.position = flash_position
	projectile_container.add_child(muzzle_flash_instance)

func spawn_floating_text(text_position : Vector2, text_value : String):
	var floating_text_instance = floating_text_scene.instantiate()
	floating_text_instance.position = text_position
	floating_text_instance.text = text_value
	text_container.add_child(floating_text_instance)

func pc_shoots_projectile(projectile_velocity : Vector2, projectile_offset : Vector2, damage : float):
	spawn_projectile(pc_node.position + projectile_offset, projectile_velocity, TeamConstants.Teams.PLAYER, damage)
	spawn_muzzle_flash(pc_node.position + projectile_offset)

func _on_player_character_projectile_shot(projectile_velocity, projectile_offset, damage):
	pc_shoots_projectile(projectile_velocity, projectile_offset, damage)

func set_pc_shooting(shooting_flag : bool = true):
	pc_node.is_shooting = shooting_flag

func set_pc_direction(facing_direction : Vector2):
	pc_node.face_direction(facing_direction)

func set_pc_cycle_next():
	pc_node.cycle_next()

func set_pc_cycle_prev():
	pc_node.cycle_prev()

func _on_enemy_damage_taken(enemy_position : Vector2, damage : float):
	spawn_floating_text(enemy_position, str(damage))

func _attach_enemy_signals():
	for child in character_container.get_children():
		if child.is_in_group(TeamConstants.ENEMY_GROUP):
			if child.has_signal("damage_taken"):
				child.damage_taken.connect(_on_enemy_damage_taken)
		
func _ready():
	_attach_enemy_signals()
