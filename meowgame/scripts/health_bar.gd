extends ProgressBar

var player: CharacterBody2D

func _ready():
	await get_tree().process_frame
	
	player = get_tree().get_first_node_in_group("player")
	if player:
		print("Found player node")
		max_value = player.max_health
		value = player.current_health
		player.health_changed.connect(_on_player_health_changed)
	else:
		print("Could not find player node")

func _on_player_health_changed(new_health: float):
	print("Health changed to:", new_health)
	value = new_health
