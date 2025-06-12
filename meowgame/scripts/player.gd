extends CharacterBody2D

@export var speed = 400
@export var acceleration = 2000
@export var friction = 1800
@export var gravity = 500
@export var jump_force = -415
@export var max_health = 100.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_attack: Area2D = $SwordAttack
@onready var inventory = $"../CanvasLayer/Control"

var bullet_scene: PackedScene
var current_health: float
var facing_right := true
var idle_timer: float = 0.0
var idle_threshold: float = 0.05

signal health_changed(new_health: float)

func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health)
	add_to_group("player")
	bullet_scene = load("res://scenes/bullet.tscn")

func take_damage(amount: float):
	current_health = clamp(current_health - amount, 0, max_health)
	emit_signal("health_changed", current_health)
	
	# Visual feedback
	if sprite:
		sprite.modulate = Color(1, 0, 0, 1)
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.2)
	
	if current_health <= 0:
		die()

func heal(amount: float):
	current_health = clamp(current_health + amount, 0, max_health)
	emit_signal("health_changed", current_health)

func die():
	queue_free()

func _input(event):
	if event.is_action_pressed("ui_accept"):  # Enter
		heal(10)
	elif event.is_action_pressed("swing_sword"):
		if inventory.is_equipped("sword"):
			print("Attempting sword swing")
			sword_attack.swing()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if inventory.is_equipped("sword"):
			print("Attempting sword swing")
			sword_attack.swing()
		elif inventory.is_equipped("handgun"):
			shoot_at_mouse()

func shoot_at_mouse():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.position = sprite.global_position
	
	var mouse_pos = get_global_mouse_position()
	bullet.direction = (mouse_pos - bullet.position).normalized()
	
	bullet.rotation = bullet.direction.angle()

func _physics_process(delta):
	var was_on_floor = is_on_floor()
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
		# Check if we're moving up or down to determine which animation to play
		if velocity.y < 0:
			if sprite.animation != "jump" and sprite.animation != "jump_end":
				sprite.play("jump")
		elif velocity.y > 0:
			if sprite.animation != "fall" and sprite.animation != "fall_end":
				sprite.play("fall")
	
	var dir := Vector2.ZERO
	if Input.is_action_pressed("d"):  # Change to D key
		dir.x += 1
		facing_right = true
		sprite.flip_h = facing_right
	if Input.is_action_pressed("a"):  # Change to A key
		dir.x -= 1
		facing_right = false
		sprite.flip_h = facing_right
	
	# Apply acceleration/deceleration
	if dir.x != 0:
		velocity.x = move_toward(velocity.x, dir.x * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	if Input.is_action_just_pressed("space") and is_on_floor():  # Change to spacebar
		velocity.y = jump_force
		sprite.play("jump")
		sprite.animation_finished.connect(_on_jump_animation_finished, CONNECT_ONE_SHOT)

	# Handle collisions and movement
	move_and_slide()
	
	# Animation states
	if is_on_floor():
		if not was_on_floor:  # Just landed
			idle_timer = 0.0
			if dir.x != 0:
				sprite.play("walk")
			else:
				sprite.animation = "walk"  # Set animation without playing
				sprite.frame = 0  # Reset to idle frame
		elif dir.x != 0:
			idle_timer = 0.0
			if sprite.animation != "walk":
				sprite.play("walk")
		else:
			# Update idle timer when not moving
			idle_timer += delta
			if idle_timer >= idle_threshold:
				if sprite.animation != "idle":
					sprite.animation = "idle"
					sprite.play()
			else:
				if sprite.animation != "walk" or sprite.is_playing():
					sprite.animation = "walk"  # Set animation without playing
					sprite.frame = 0  # Reset to idle frame
	else:
		idle_timer = 0.0  # Reset timer when in air
	
	# Update sword direction
	if sword_attack and sprite:
		var hand_offset = Vector2(48, 16) * (1 if facing_right else -1)
		sword_attack.position = sprite.position + hand_offset
		sword_attack.set_facing(facing_right)

func _on_jump_animation_finished():
	if sprite.animation == "jump":
		sprite.animation = "jump_end"  # Create this state in your AnimatedSprite
		sprite.frame = sprite.sprite_frames.get_frame_count("jump") - 1
		sprite.stop()

func _on_fall_animation_finished():
	if sprite.animation == "fall":
		sprite.animation = "fall_end"  # Create this state in your AnimatedSprite
		sprite.frame = sprite.sprite_frames.get_frame_count("fall") - 1
		sprite.stop()
