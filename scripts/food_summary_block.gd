extends Control

@onready var topping_icon = $MarginContainer/HBoxContainer/topping_icon
@onready var amount = $MarginContainer/HBoxContainer/topping_number



func set_icon_and_amount(food: String, x: int):
	# Find the path the the food image and set it as the topping sprite texture
	var path = "res://assets/images/ingredients/%s.png" % food
	
	if ResourceLoader.exists(path, "Texture2D"):
		var tex = load(path) as Texture2D
		topping_icon.texture = tex
	else:
		push_warning("Texture not found: %s" % path)
	
	# Set the number label
	amount.text = str(x)
	
