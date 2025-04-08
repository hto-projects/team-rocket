extends Node2D

@onready var player = $"../Player"
@onready var tilemap = $"../TileMap"
@onready var inventory = $"../CanvasLayer/Control"

@export var max_range: float = 64.0
@export var highlight_color: Color = Color(1, 1, 1, 0.3)
@export var tile_size: Vector2 = Vector2(16, 16)

var highlighted_tile: Vector2i = Vector2i(-1, -1)

func _process(_delta):
	update_highlight()

func update_highlight():
	var player_pos = player.global_position
	var nearest_tile = Vector2i(-1, -1)
	var nearest_distance = max_range

	var player_tile_pos = tilemap.local_to_map(tilemap.to_local(player_pos))

	for x in range(-3, 4):
		for y in range(-3, 4):
			var tile_pos = player_tile_pos + Vector2i(x, y)

			if tilemap.get_cell_source_id(0, tile_pos) != -1:
				var world_pos = tilemap.to_global(tilemap.map_to_local(tile_pos))
				var distance = player_pos.distance_to(world_pos)

				if distance < nearest_distance:
					nearest_tile = tile_pos
					nearest_distance = distance

	highlighted_tile = nearest_tile
	queue_redraw()

func _draw():
	if highlighted_tile != Vector2i(-1, -1):
		var world_pos = tilemap.to_global(tilemap.map_to_local(highlighted_tile))
		draw_rect(Rect2(world_pos, tile_size), highlight_color, false)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if inventory.is_equipped("pickaxe") and highlighted_tile != Vector2i(-1, -1):
			tilemap.erase_cell(0, highlighted_tile)
			print("Destroyed tile at:", highlighted_tile)
