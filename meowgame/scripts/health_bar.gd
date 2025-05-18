extends ProgressBar

@export var player_path: NodePath
var player: CharacterBody2D

func _ready():
	player = get_node(player_path)
	if player:
		max_value = player.max_health
		value = player.current_health
		player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_health: float):
	value = new_health
