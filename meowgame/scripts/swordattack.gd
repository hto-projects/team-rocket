extends Area2D

@export var damage := 20.0
@export var swing_duration := 0.2
@export var swing_start_angle := -90.0
@export var swing_end_angle := 90.0

var is_swinging := false
var facing_right := true

func _ready():
	monitoring = false
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	rotation_degrees = swing_start_angle

func swing():
	if is_swinging:
		return
		
	is_swinging = true
	monitoring = true
	$CollisionShape2D.disabled = false
	$Sprite2D.visible = true
	
	var start = swing_start_angle if facing_right else -swing_start_angle
	var end = swing_end_angle if facing_right else -swing_end_angle
	
	# Reset to start position
	rotation_degrees = start
	
	# Create and configure the swing tween
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", end, swing_duration)
	tween.finished.connect(_on_swing_finished)

func set_facing(is_right: bool):
	facing_right = is_right
	scale.x = 1 if facing_right else -1
	scale.y = 1
	if not is_swinging:
		rotation_degrees = swing_start_angle if facing_right else -swing_start_angle

func _on_swing_finished():
	is_swinging = false
	monitoring = false
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false

func _on_body_entered(body):
	if body.has_method("take_damage") and is_swinging:
		body.take_damage(damage)
