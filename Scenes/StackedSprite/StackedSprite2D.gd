@tool
extends Sprite2D

@export var show_sprites : bool = false : set = set_show_sprites
@export var y_offset : float = 1.0
@export_range(-PI, PI) var sprite_rotation_offset : float = 0 : set = set_sprite_rotation_offset

var sprite_rotation : float = 0 : set = set_sprite_rotation

func set_show_sprites(_show_sprites):
	show_sprites = _show_sprites
	if show_sprites:
		render_sprites()
	else:
		clear_sprites()

func _update_sprite_rotations():
	for sprite in get_children():
		sprite.rotation = sprite_rotation + sprite_rotation_offset

func set_sprite_rotation(new_rotation):
	sprite_rotation = new_rotation
	_update_sprite_rotations()

func set_sprite_rotation_offset(new_rotation_offset):
	sprite_rotation_offset = new_rotation_offset
	_update_sprite_rotations()

func clear_sprites():
	for sprite in get_children():
		sprite.queue_free()

func _ready():
	render_sprites()

func render_sprites():
	clear_sprites()
	for i in range(0, hframes):
		var next_sprite = Sprite2D.new()
		next_sprite.texture = texture
		next_sprite.hframes = hframes
		next_sprite.frame = i
		next_sprite.position.y = -i * y_offset
		add_child(next_sprite)

func _on_texture_changed():
	render_sprites()
	set_sprite_rotation(sprite_rotation)
