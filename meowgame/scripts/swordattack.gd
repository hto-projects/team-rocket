extends Area2D

@export var damage := 20.0
@export var swing_duration := 0.3
@export var swing_angle := 90.0

var is_swinging := false

func _ready():
	monitoring = false
	monitorable = false

func swing():
	if is_swinging:
		return
		
	is_swinging = true
	monitoring = true
	monitorable = true
	
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", swing_angle, swing_duration/2)
	tween.tween_property(self, "rotation_degrees", 0.0, swing_duration/2)
	tween.finished.connect(_on_swing_finished)
	
	$Sprite2D.visible = true

func _on_swing_finished():
	is_swinging = false
	monitoring = false
	monitorable = false
	$Sprite2D.visible = false

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
