extends Area2D

const SPEED = 800
var direction := Vector2.ZERO
var damage := 10.0

func _ready():
	collision_layer = 0
	collision_mask = 8
	monitoring = true
	$Timer.start()

func _physics_process(delta):
	position += direction * SPEED * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_timer_timeout():
	queue_free()
