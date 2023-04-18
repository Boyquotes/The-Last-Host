extends Node2D
class_name World

@onready var pc_node = $CharacterContainer/PlayerCharacter
@onready var projectile_container = $ProjectileContainer
var projectile_scene = preload("res://Scenes/Projectile/Projectile.tscn")

func spawn_projectile(projectile_position : Vector2, projectile_velocity : Vector2, team : GameConstants.TeamsEnum):
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.position = projectile_position
	projectile_instance.velocity = projectile_velocity
	projectile_instance.team = team
	projectile_container.add_child(projectile_instance)

func pc_shoots_projectile(projectile_velocity : Vector2, projectile_offset : Vector2):
	spawn_projectile(pc_node.position + projectile_offset, projectile_velocity, GameConstants.TeamsEnum.PLAYER)

func set_pc_shooting(shooting_flag : bool = true):
	pc_node.is_shooting = shooting_flag

func _on_player_character_projectile_shot(projectile_velocity, projectile_offset):
	pc_shoots_projectile(projectile_velocity, projectile_offset)

func set_pc_direction(facing_direction : Vector2):
	pc_node.face_direction(facing_direction)

func set_pc_cycle_next():
	pc_node.cycle_next()

func set_pc_cycle_prev():
	pc_node.cycle_prev()
