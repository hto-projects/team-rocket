extends Node

@export var mob_scene: PackedScene

func _ready():
	# Spawn a mob at a specific position
	if mob_scene:
		var mob = mob_scene.instantiate()
		mob.position = Vector2(400, 400) # Adjust as needed
		add_child(mob)
