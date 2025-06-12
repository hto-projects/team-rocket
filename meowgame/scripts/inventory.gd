extends Control

var inventory = {
	"pickaxe": false,
	"block": false,
	"sword": false,
	"handgun": false
}

func equip_item(item_name: String):
	if item_name in inventory:
		# Unequip all other items first
		for item in inventory:
			inventory[item] = false
		inventory[item_name] = true
		print(item_name + " equipped!")

func unequip_item(item_name: String):
	if item_name in inventory:
		inventory[item_name] = false
		print(item_name + " unequipped!")

func is_equipped(item_name: String) -> bool:
	return inventory.get(item_name, false)
