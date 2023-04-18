extends Resource
class_name WeaponData

@export var sprite_stack : Texture 
@export_range(0, 16) var sprite_stack_layers : int
@export_range(-32, 32) var weapon_offset : float
@export_range(-32, 32) var barrel_offset : float
@export_range(0, 1200) var projectile_speed : float
@export_range(0, 120) var cooldown : float
@export_range(0, 9999) var damage : int
