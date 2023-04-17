extends Node2D
class_name World

@onready var character_node = $CharacterContainer/PlayerCharacter


### test ###

func _ready():
	get_tree().set_group("enemies", "player_node", character_node)

### end test ###
