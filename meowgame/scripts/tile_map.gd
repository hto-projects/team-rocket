extends TileMap

@onready var inventory = $"../CanvasLayer/Control"

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_local_mouse_position()
		var tile_pos = local_to_map(mouse_pos)
		
		if inventory.is_equipped("pickaxe"):
			if get_cell_source_id(0, tile_pos) != -1:
				erase_cell(0, tile_pos)
				print("Tile destroyed!")
		
		elif inventory.is_equipped("block"):
			if get_cell_source_id(0, tile_pos) == -1:
				set_cell(0, tile_pos, 1, Vector2i(0, 0))  # Using source_id 1 for the tileset
				print("Tile placed!")
