extends ProgressBar

@onready var enemy = get_parent()

func _ready():
	max_value = enemy.max_health
	value = enemy.current_health
	size = Vector2(50, 1)
	position = Vector2(-24, 12)
	
	show_percentage = false
	modulate = Color(1, 0, 0)

func _process(_delta):
	value = enemy.current_health
