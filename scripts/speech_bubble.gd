extends Control

@export var label_font : FontFile
@onready var order_container = $OrderContainer
@onready var bubble = $Bubble_Rect
@onready var anim_player = $AnimationPlayer

var HoverLabelScene = preload("res://scenes/UI/hover_label.tscn")

var MAX_FONT_SIZE = 64
var MIN_FONT_SIZE = 32
var FONT_STEP = 4
var BUBBLE_SIZE = Vector2(950, 400)
var VERTICAL_PADDING = 20

func display_order(toppings: Array) -> void:
	await get_tree().create_timer(0.5).timeout
	anim_player.play("fade_in")
	
	var font_size = MAX_FONT_SIZE
	# Start at max and decrease every loop until it fits
	while font_size >= MIN_FONT_SIZE:
		clear_order()
		
		# Try to display with current font size
		generate_labels(toppings, font_size)
		
		await get_tree().process_frame
		await get_tree().process_frame  # Wait for layout
		
		var content_height = get_content_height()
		if content_height + VERTICAL_PADDING <= BUBBLE_SIZE.y:
			break
		
		font_size -= FONT_STEP
	
	# Center container inside bubble
	center_order_container()

func generate_labels(toppings: Array, font_size: int):
	# Intro text
	var words = ["Can", "I", "get", "a", "pizza", "with"]
	for word in words:
		add_word_label(word, font_size)
	
	# Toppings
	for i in range(toppings.size()):
		var topping = toppings[i]
		var count = topping["count"]
		var topping_name = topping["name"]
		
		# Add comma or "and" depending on position
		if i > 0 and i == toppings.size() - 1:
			add_word_label("and", font_size)
		elif i > 0:
			add_word_label(",", font_size)
			
		if topping_name == "cheese":
			add_hover_label("cheese", font_size)
		else:
			var number_word = FoodTruck.num_to_words(count)
			var plural_name = FoodTruck.pluralize(topping_name, count)
			
			add_hover_label(number_word, font_size)
			add_hover_label(plural_name, font_size)
			
	add_word_label("?", font_size)

func add_word_label(text: String, font_size: int) -> void:
	var label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", Color.BLACK)
	label.add_theme_font_override("font", label_font)
	label.add_theme_font_size_override("font_size", font_size)
	order_container.add_child(label)

func add_hover_label(text: String, font_size: int) -> void:
	var hover_label = HoverLabelScene.instantiate()
	set_hover_label(hover_label, text, font_size)
	order_container.add_child(hover_label)

func set_hover_label(label: Label, text: String, font_size: int):
	label.text = text
	label.add_theme_font_override("font", label_font)
	label.add_theme_font_size_override("font_size", font_size)
	
	if "randomize_color" in label:
		label.randomize_color()
	
	if "update_collision_shape" in label:
		await get_tree().process_frame
		label.update_collision_shape()

func center_order_container():
	var container_height = get_content_height()
	var offset_y = -((container_height) / 2)
	order_container.position.y = offset_y

func get_content_height() -> float:
	var min_y = INF
	var max_y = -INF
	
	for child in order_container.get_children():
		if child is Control:
			var top = child.position.y
			var bottom = child.position.y + child.size.y
			min_y = min(min_y, top)
			max_y = max(max_y, bottom)
	
	if min_y == INF or max_y == -INF:
		return 0
	
	return max_y - min_y

func clear_order():
	for child in order_container.get_children():
		child.queue_free()
