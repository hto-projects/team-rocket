extends CharacterBody2D

@export var max_health: float = 30.0
@export var speed: float = 60.0
@export var damage: float = 10.0
@export var patrol_distance: float = 100.0
@export var knockback_force: float = 300.0

var current_health: float
var direction: int = 1
var start_x: float
var can_damage: bool = true  # Cooldown flag for damage

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Area2D

func _ready():
	current_health = max_health
	start_x = position.x
	if sprite:
		sprite.play("fly")
	hitbox.body_entered.connect(_on_body_entered)
	hitbox.area_entered.connect(_on_area_entered)
	
	var health_bar = ProgressBar.new()
	health_bar.set_script(load("res://scripts/enemy_health_bar.gd"))
	add_child(health_bar)

func _physics_process(delta):
	# Simple left-right patrol
	position.x += direction * speed * delta
	if abs(position.x - start_x) > patrol_distance:
		direction *= -1
		if sprite:
			sprite.flip_h = direction < 0
			
	# Move and check for collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("player") and can_damage:
			if collider.has_method("take_damage"):
				collider.take_damage(damage)
				var knockback = (collider.global_position - global_position).normalized() * knockback_force
				collider.velocity = knockback
				
				can_damage = false
				var timer = get_tree().create_timer(0.5)
				timer.timeout.connect(func(): can_damage = true)

func take_damage(amount: float):
	current_health -= amount
	if current_health <= 0:
		die()

	modulate = Color(1, 0, 0, 1)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)

func die():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player") and can_damage:
		if body.has_method("take_damage"):
			body.take_damage(damage)
			
			# Apply knockback to the player
			var knockback_direction = (body.global_position - global_position).normalized()
			if body is CharacterBody2D:
				body.velocity = knockback_direction * knockback_force
			
			# Add damage cooldown
			can_damage = false
			var timer = get_tree().create_timer(0.5)  # 0.5 second cooldown
			timer.timeout.connect(func(): can_damage = true)

func _on_area_entered(area):
	var damage_value = area.get("damage")
	if damage_value != null:
		take_damage(damage_value)
