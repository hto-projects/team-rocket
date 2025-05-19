extends Area2D

@export var damage := 20.0
@export var swing_duration := 0.2
@export var swing_start_angle := -90.0  # Start straight up (right-facing)
@export var swing_end_angle := 90.0     # End straight down (right-facing)

var is_swinging := false
var facing_right := true

func _ready():
	monitoring = false
	monitorable = false
	rotation_degrees = swing_start_angle

func swing():
	if is_swinging:
		return
		
	is_swinging = true
	monitoring = true
	monitorable = true
	
	# Terraria-like semicircle arc
	var start = swing_start_angle if facing_right else -swing_start_angle
	var end = swing_end_angle if facing_right else -swing_end_angle
	
	rotation_degrees = start
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", end, swing_duration)
	tween.finished.connect(_on_swing_finished)
	
	$Sprite2D.visible = true

func set_facing(is_right: bool):
	facing_right = is_right
	scale.x = 1 if facing_right else -1
	scale.y = 1
	rotation_degrees = swing_start_angle if facing_right else -swing_start_angle

func _on_swing_finished():
	is_swinging = false
	monitoring = false
	monitorable = false
	$Sprite2D.visible = false

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
