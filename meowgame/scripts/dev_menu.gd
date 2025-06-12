extends CanvasLayer

var properties = {
	"Speed": ["speed", 400, 0, 2000],
	"Acceleration": ["acceleration", 2000, 0, 5000],
	"Friction": ["friction", 1800, 0, 5000],
	"Gravity": ["gravity", 500, 0, 2000],
	"Jump Force": ["jump_force", -300, -1000, 0],
	"Max Health": ["max_health", 100, 0, 1000]
}

var enemy_scene = preload("res://scenes/enemybig.tscn")

func _ready():
	var menu = Control.new()
	menu.set_anchors_preset(Control.PRESET_CENTER)
	add_child(menu)
	
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(600, 700)
	panel.position = Vector2(-300, -350)  # Half the size to center
	menu.add_child(panel)
	
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(560, 660)
	scroll.position = Vector2(20, 20)
	panel.add_child(scroll)
	
	var vbox = VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(540, 0)
	scroll.add_child(vbox)
	
	for prop_name in properties:
		var container = HBoxContainer.new()
		container.custom_minimum_size = Vector2(0, 40)
		vbox.add_child(container)
		
		var label = Label.new()
		label.text = prop_name + ": "
		label.custom_minimum_size = Vector2(150, 0)
		container.add_child(label)
		
		var slider = HSlider.new()
		var prop_data = properties[prop_name]
		slider.min_value = prop_data[2]
		slider.max_value = prop_data[3]
		slider.value = prop_data[1]
		slider.custom_minimum_size = Vector2(250, 0)
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.mouse_filter = Control.MOUSE_FILTER_STOP
		slider.value_changed.connect(_on_value_changed.bind(prop_data[0]))
		container.add_child(slider)
		
		var value_label = Label.new()
		value_label.text = str(slider.value)
		value_label.custom_minimum_size = Vector2(80, 0)
		slider.value_changed.connect(func(val): value_label.text = str(val))
		container.add_child(value_label)
	
	# Add spawn enemy button
	var spawn_container = HBoxContainer.new()
	spawn_container.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(spawn_container)
	
	var spawn_button = Button.new()
	spawn_button.text = "Spawn Enemy"
	spawn_button.custom_minimum_size = Vector2(200, 30)
	spawn_button.pressed.connect(_on_spawn_enemy)
	spawn_container.add_child(spawn_button)

	# Start hidden
	menu.visible = false

func _input(event):
	if event.is_action_pressed("toggle_dev_menu"):
		get_child(0).visible = !get_child(0).visible
		get_tree().paused = get_child(0).visible

func _on_value_changed(value: float, property: String):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set(property, value)
		if property == "max_health":
			player.current_health = value
			player.emit_signal("health_changed", value)

func _on_spawn_enemy():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var enemy = enemy_scene.instantiate()
		# Spawn enemy 100 pixels to the right of player
		enemy.position = player.position + Vector2(100, 0)
		enemy.scale = Vector2(3, 3)  # Match the scale used in main scene
		player.get_parent().add_child(enemy)
		print("Enemy spawned!")
