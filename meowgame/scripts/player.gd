extends CharacterBody2D

@export var speed = 100
@export var gravity = 500
@export var jump_force = -300
@export var max_health = 100.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_attack: Area2D = $SwordAttack
@onready var inventory = $"../CanvasLayer/Control"

var current_health: float
var facing_right := true

signal health_changed(new_health: float)

func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health)
	add_to_group("player")

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
	if event.is_action_pressed("ui_select"):  # Spacebar
		take_damage(10)
	elif event.is_action_pressed("ui_accept"):  # Enter
		heal(10)
	elif event.is_action_pressed("swing_sword"):
		if inventory.is_equipped("sword"):
			print("Attempting sword swing")
			sword_attack.swing()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if inventory.is_equipped("sword"):
			print("Attempting sword swing")
			sword_attack.swing()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var dir := Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
		facing_right = true
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
		facing_right = false
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force

	velocity.x = dir.x * speed
	move_and_slide()
	
	# Update sword direction based on facing
	if sword_attack and sprite:
		# Place sword at player's hand height, next to the player
		var hand_offset = Vector2(48, 16) * (1 if facing_right else -1)
		sword_attack.position = sprite.position + hand_offset
		sword_attack.set_facing(facing_right)

	if is_on_floor():
		if dir.x != 0:
			if sprite.animation != "walk" or not sprite.is_playing():
				sprite.play("walk")
			sprite.flip_h = facing_right
		else:
			sprite.stop()
			sprite.frame = 0
	else:
		sprite.stop()
