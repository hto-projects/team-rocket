extends TileMap

@onready var inventory = $"../CanvasLayer/Control"

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var tile_pos = local_to_map(mouse_pos)
		
		# If using a pickaxe, try to remove a tile.
		if inventory.is_equipped("pickaxe"):
			if get_cell_atlas_coords(0, tile_pos) != Vector2i(-1, -1):
				erase_cell(0, tile_pos)
				print("Tile destroyed!")
			else:
				print("No tile to destroy at this location!")
		
		# If using a block, try to add a tile.
		elif inventory.is_equipped("block"):
			# Check if the target position has no tile.
			if get_cell_atlas_coords(0, tile_pos) == Vector2i(-1, -1):
				# Set the cell to have tile index 0. Change the index as needed.
				set_cell(0, tile_pos)
				print("Tile added!")
			else:
				print("There's already a tile here!")
