extends Resource
class_name WeaponData

@export var name : String
@export var sprite_stack : Texture 
@export_range(0, 16) var sprite_stack_layers : int
@export_range(-32, 32) var weapon_offset : float # Distance from the players body
@export_range(-32, 32) var y_offset : float # For within the sprite stack
@export_range(-32, 32) var barrel_offset : float # Distance from weapon_offset that the barrel and muzzle flash occur
@export_range(0, 1200) var projectile_speed : float
@export_range(0, 120) var cooldown : float
@export_range(0, 9999) var damage : int
@export var projectile_scene : PackedScene
@export var casing_scene : PackedScene
