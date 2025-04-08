extends CharacterBody2D

@export var speed = 100
@export var gravity = 500
@export var jump_force = -300

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force

	velocity.x = direction.x * speed
	move_and_slide()
