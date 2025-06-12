extends TextureRect

@onready var inventory = $"../Control"

func _ready():
	$Button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if inventory.is_equipped("handgun"):
		inventory.unequip_item("handgun")
	else:
		inventory.equip_item("handgun")
