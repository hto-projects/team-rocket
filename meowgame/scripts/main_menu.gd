extends Control

# Paths to your game scenes
const SCENE_GAMEPLAY := "res://scenes/main.tscn"
const SCENE_OPTIONS  := "res://scenes/OptionsMenu.tscn"

@onready var parallax = $ParallaxBackground

# Scrolling speed for background (pixels per second)
@export var scroll_speed = 50

func _ready():
	$Panel/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$Panel/VBoxContainer/OptionsButton.pressed.connect(_on_options_pressed)
	$Panel/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _process(delta):
	# Move all parallax layers continuously
	parallax.scroll_offset.x -= scroll_speed * delta

func _on_start_pressed() -> void:
	# Change to your gameplay scene
	get_tree().change_scene_to_file(SCENE_GAMEPLAY)

func _on_options_pressed() -> void:
	# Push an options screen on top
	var options = load(SCENE_OPTIONS).instantiate()
	add_child(options)

func _on_quit_pressed() -> void:
	# Gracefully quit the game
	get_tree().quit()
