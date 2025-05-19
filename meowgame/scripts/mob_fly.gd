extends CharacterBody2D

@export var max_health: float = 30.0
@export var speed: float = 60.0
@export var damage: float = 10.0
@export var patrol_distance: float = 100.0

var current_health: float
var direction: int = 1
var start_x: float

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Area2D

func _ready():
	current_health = max_health
	start_x = position.x
	if sprite:
		sprite.play("fly")
	hitbox.body_entered.connect(_on_body_entered)
	hitbox.area_entered.connect(_on_area_entered)

func _physics_process(delta):
	# Simple left-right patrol
	position.x += direction * speed * delta
	if abs(position.x - start_x) > patrol_distance:
		direction *= -1
		if sprite:
			sprite.flip_h = direction < 0

func take_damage(amount: float):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)

func _on_area_entered(area):
	# SwordAttack is an Area2D, so check for its script/class
	if area.has_method("take_damage"):
		# If the sword itself has a take_damage, ignore (shouldn't)
		return
	# If the area has a "damage" property, use it, otherwise use a default
	if area.has_variable("damage"):
		take_damage(area.damage)
