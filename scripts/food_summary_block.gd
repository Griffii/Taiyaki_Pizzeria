extends Control

@onready var topping_icon = $MarginContainer/HBoxContainer/topping_icon
@onready var amount = $MarginContainer/HBoxContainer/topping_number

@onready var shutter_menu = $"../../../../../.."

func set_icon_and_amount(food: String, food_desired: bool, x: int, number_desired: bool):
	# Find the path to the food image and set it as the topping sprite texture
	var path = "res://assets/images/ingredients/%s.png" % food
	
	if ResourceLoader.exists(path, "Texture2D"):
		var tex = load(path) as Texture2D
		topping_icon.texture = tex
	else:
		push_warning("Texture not found: %s" % path)
		
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
