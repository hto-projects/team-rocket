extends Camera2D

var custom_offset: Vector2 = Vector2(0, -100)

func _ready() -> void:
	make_current()
	global_position = Vector2(400, 300)


func _process(delta: float) -> void:
	if get_parent() != null:
		global_position = get_parent().global_position + custom_offset
