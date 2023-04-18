extends Node2D
class_name World

@onready var pc_node = $CharacterContainer/PlayerCharacter
@onready var projectile_container = $ProjectileContainer
var projectile_scene = preload("res://Scenes/Projectile/Projectile.tscn")

func spawn_projectile(projectile_position : Vector2, projectile_velocity : Vector2):
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.position = projectile_position
	projectile_instance.velocity = projectile_velocity
	projectile_container.add_child(projectile_instance)

func pc_shoots_projectile(projectile_velocity : Vector2):
	spawn_projectile(pc_node.position, projectile_velocity)

func set_pc_shooting(shooting_flag : bool = true):
	pc_node.is_shooting = shooting_flag

func _on_player_character_projectile_shot(projectile_velocity):
	pc_shoots_projectile(projectile_velocity)
