extends Control

@onready var topping_icon = $MarginContainer/HBoxContainer/topping_icon
@onready var amount = $MarginContainer/HBoxContainer/topping_number

@onready var shutter_menu = $"../../../../../.."

var all_toppings = {
	# Veggies
	"cabbage": preload("res://assets/images/ingredients/Cabbage.png"),
	"carrot": preload("res://assets/images/ingredients/Carrot.png"),
	"cheese": preload("res://assets/images/ingredients/Cheese.png"),
	"corn": preload("res://assets/images/ingredients/Corn.png"),
	"cucumber": preload("res://assets/images/ingredients/Cucumber.png"),
	"green pepper": preload("res://assets/images/ingredients/Green Pepper.png"),
	"mushroom": preload("res://assets/images/ingredients/Mushroom.png"),
	"onion": preload("res://assets/images/ingredients/Onion.png"),
	"pepperoni": preload("res://assets/images/ingredients/Pepperoni.png"),
	"potato": preload("res://assets/images/ingredients/Potato.png"),
	"tomato": preload("res://assets/images/ingredients/Tomato.png"),
	# Fruit
	"apple": preload("res://assets/images/ingredients/Apple.png"),
	"banana": preload("res://assets/images/ingredients/Banana.png"),
	"cherry": preload("res://assets/images/ingredients/Cherry.png"),
	"kiwi fruit": preload("res://assets/images/ingredients/Kiwi.png"),
	"melon": preload("res://assets/images/ingredients/Melon.png"),
	"orange": preload("res://assets/images/ingredients/Orange.png"),
	"peach": preload("res://assets/images/ingredients/Peach.png"),
	"pineapple": preload("res://assets/images/ingredients/Pineapple.png"),
	"strawberry": preload("res://assets/images/ingredients/Strawberry2.png"),
	# Ice Cream
	"vanilla ice cream": preload("res://assets/images/ingredients/Vanilla Icecream.png"),
	"chocolate ice cream": preload("res://assets/images/ingredients/Chocolate Icecream.png"),
	"strawberry ice cream": preload("res://assets/images/ingredients/Strawberry Icecream.png")
}



func set_icon_and_amount(food: String, food_desired: bool, x: int, number_desired: bool):
	# Set texture
	topping_icon.texture = all_toppings.get(food, null)
	# Set the number label
	amount.text = str(x)
	
	# Duplicate the shader material to make it unique for this instance
	if topping_icon.material:
		var original_shader = topping_icon.material
		var unique_shader = original_shader.duplicate()
		topping_icon.material = unique_shader
		
	# Set shader glow color and size based on food_desired
	var shader_mat = topping_icon.material as ShaderMaterial
	if shader_mat:
		shader_mat.set_shader_parameter("glow_enabled", true)
		shader_mat.set_shader_parameter("glow_size", 25)
		
		if food_desired:
			shader_mat.set_shader_parameter("glow_color", Color(0.6, 1.0, 0.6))  # green
		else:
			shader_mat.set_shader_parameter("glow_color", Color(2.0, 0.1, 0.1))  # red
	
	# Ensure the label has a StyleBoxFlat for background override
	var stylebox := amount.get("theme_override_styles/normal") as StyleBoxFlat
	
	if stylebox == null:
		stylebox = StyleBoxFlat.new()
	else:
		stylebox = stylebox.duplicate()
	
	amount.add_theme_stylebox_override("normal", stylebox)
	
	# Flash color and fade to target color
	var flash_color: Color
	var target_color: Color
	
	if number_desired:
		flash_color = Color(1.0, 1.0, 1.0, 0.5)  # flash white
		target_color = Color(0.6, 1.0, 0.6, 0.5)  # green
	else:
		flash_color = Color(1.0, 1.0, 1.0, 0.5)  # flash white
		target_color = Color(1.0, 0.4, 0.4, 0.5)  # red
	
	# Apply flash color immediately
	stylebox.bg_color = flash_color
	
	# Create and run tween
	var tween := create_tween()
	tween.tween_property(stylebox, "bg_color", target_color, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
