extends TileMap

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = event.position
		var tile_pos = local_to_map(mouse_pos)

		if get_cell_source_id(0, tile_pos) != -1:
			erase_cell(0, tile_pos)
