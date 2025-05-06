extends CharacterBody2D

@export var speed = 100
@export var gravity = 500
@export var jump_force = -300

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var dir := Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force

	velocity.x = dir.x * speed
	move_and_slide()

	if is_on_floor():
		if dir.x != 0:
			if sprite.animation != "walk" or not sprite.is_playing():
				sprite.play("walk")
			sprite.flip_h = dir.x < 0
		else:
			sprite.stop()
			sprite.frame = 0
	else:
		sprite.stop()
