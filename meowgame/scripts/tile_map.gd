extends TileMap

@onready var inventory = $"../CanvasLayer/Control"

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if inventory.is_equipped("pickaxe"):
			var mouse_pos = get_global_mouse_position()
			var tile_pos = local_to_map(mouse_pos)

			if get_cell_atlas_coords(0, tile_pos) != Vector2i(-1, -1):
				erase_cell(0, tile_pos)
				print("Tile destroyed!")
		else:
			print("You need a pickaxe to break tiles!")
