extends TextureRect

@onready var inventory = $"../Control"

func _ready():
	$Button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if inventory.is_equipped("block"):
		inventory.unequip_item("block")
	else:
		inventory.equip_item("block")
