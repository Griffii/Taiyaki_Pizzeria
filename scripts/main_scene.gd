extends Node2D

@onready var lock_button = $ButtonsLayer/Lock_Button
@onready var pizza_area = $"The_Pizza/PizzaArea"
@onready var pizza_toppings_container = $"PizzaToppings"
@onready var bell_button = $"Decorations Container/Bell"
@onready var shutter_close_button = $ButtonsLayer/Close_Button
@onready var shutter_menu = $Shutter_Menu
@onready var speech_bubble = $"Customer_Container/Bubble"
@onready var bell = $"Decorations Container/Bell"
@onready var customer = $Customer_Container/Customer
@onready var timer = $"Decorations Container/Timer"
@onready var home_freeplay = $ButtonsLayer/HomeButton_FreePlay
@onready var settings_menu = %Settings_Menu
@onready var camera_controls = $UI_Layer

# Sounds
@onready var beep_sound = $SFX_Container/beep_sound
@onready var next_sound = $SFX_Container/next_sound
@onready var back_sound = $SFX_Container/back_sound


func _ready() -> void:
	if !FoodTruck.free_play:
		bell_button.bell_pressed.connect(bell_pressed) # Connect the bell pressed signal
		
		customer.random_customer()
		customer.anim_player.play("walk_in")
		await customer.anim_player.animation_finished
		
		FoodTruck.generate_pizza_order()
		speech_bubble.display_order(FoodTruck.desired_toppings)
		
		shutter_menu.order.text = FoodTruck.current_order
		
		# Reset global cash_total var
		FoodTruck.current_cash = 0.0
	else:
		# Activate second home button
		home_freeplay.visible = true

###############################################################################
### INPUT HANDLING ############################################################
###############################################################################
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_mouse_click(event)

# Sort sprites by Z index when clicking, only pass the event to the top most sprite
func handle_mouse_click(event):
	var mouse_pos = get_global_mouse_position()
	var top_node = null
	var top_z = -999 # Used to be -INF, changed it to avoid / by float errors
	var overlapping = []
	
	# Get all the topping nodes when clicking
	for ingredient in pizza_toppings_container.get_children():
		var ctrl = ingredient.get_node("Control") as Control
		
		if ctrl.get_global_rect().has_point(mouse_pos):
			overlapping.append({"node": ingredient, "z": ctrl.z_index})
			if ctrl.z_index > top_z:
				top_z = ctrl.z_index
				top_node = ingredient
	
	## Debug: print all overlapping nodes and their z_index values
	#if overlapping.size() > 0:
		#print("\n--- Overlapping nodes at mouse ---")
		#for entry in overlapping:
			#print("• ", entry["node"].type, " (z_index: ", entry["z"], ")")
	
	## Pass the click event to the top node
	if top_node:
		#print("Top node selected: ", top_node.type)
		if top_node.has_method("_on_area_input_event"):
			top_node._on_area_input_event(null, event, 0)

###############################################################################

func set_timer(seconds: int):
	timer.start_timer(seconds)
	FoodTruck.game_time = seconds

# Count toppings on the pizza area and send to global array
func check_toppings():
	# Store all ingredient nodes in the PizzaToppings container in an array
	var all_toppings: Array = $%PizzaToppings.get_children()
	
	# Check which overlap with the pizza_area (Area2D of the pizza node) and store those in an array
	var toppings_in_pizza_area: Array = []
	
	for topping in all_toppings:
		if topping.has_node("Area2D"):
			var topping_area = topping.get_node("Area2D") as Area2D
			if pizza_area.overlaps_area(topping_area):
				toppings_in_pizza_area.append(topping)
	
	# Count how many of each type of topping are present
	var type_counts: Dictionary = {}
	
	for topping in toppings_in_pizza_area:
		var topping_type: String = topping.type
		
		if topping_type in type_counts:
			type_counts[topping_type] += 1
		else:
			type_counts[topping_type] = 1
	
	# Format into array of dicts: [{name: "Cheese", count: 1}, ...]
	var toppings_summary: Array = []
	for topping_type in type_counts.keys():
		toppings_summary.append({
			"name": topping_type,
			"count": type_counts[topping_type]
		})
		
	# Set global data
	FoodTruck.pizza_toppings = toppings_summary

# Compare toppings to desired toppings
func compare_pizza_to_order():
	var results: Array = []
	var desired_map: Dictionary = {}
	
	for d in FoodTruck.desired_toppings:
		desired_map[d["name"].to_lower()] = int(d["count"])
	
	var matched_desired: Dictionary = {}
	
	# Process player's toppings
	for topping in FoodTruck.pizza_toppings:
		var name_original: String = topping["name"]
		var name_lower: String = name_original.to_lower()
		var count: int = int(topping["count"])
		var name_correct: bool = desired_map.has(name_lower)
		var expected_count: int = 0
		var count_correct: int = 0
		
		if name_correct:
			expected_count = desired_map[name_lower]
			count_correct = min(count, expected_count)
			matched_desired[name_lower] = true
		
		# If the set count is 99, and any amount are present, it's correct and gets paid once
		# For cheese and ice creams
		if expected_count == 99 and count >= 1:
			count_correct = true
			expected_count = count
		
		results.append({
			"name": name_lower,
			"count": count,
			"expected_count": expected_count,
			"name_correct": name_correct,
			"count_correct": count_correct
		})
		
	# Add missing toppings (not on pizza at all)
	for desired in FoodTruck.desired_toppings:
		var desired_name: String = desired["name"]
		
		if not matched_desired.has(desired_name):
			results.append({
				"name": desired_name,
				"count": 0,
				"expected_count": int(desired["count"]),
				"name_correct": false,
				"count_correct": 0
			})
	
	FoodTruck.pizza_check_results = results
	
	print("--- Pizza Check Results ---")
	for r in results:
		print("  - ", r)

func bell_pressed():
	# Disable the bell
	bell.bell_area.disabled = true
	# Show / Hide the shutter menu
	shutter_menu.anim_player.play("shutter_close")
	shutter_close_button.visible = true
	
	check_toppings()
	compare_pizza_to_order()
	
	# Clear order behind the menu
	speech_bubble.clear_order()
	speech_bubble.anim_player.play("fade_out")
	
	shutter_menu.populate_food_summary()

func clear_pizza_toppings():
	for child in pizza_toppings_container.get_children():
		child.queue_free()

###############################################################################
## Buttons for rotating topping pieces ########################################
###############################################################################
func on_rotate_left_pressed():
	if FoodTruck.current_selection:
		beep_sound.play()
		FoodTruck.current_selection.rotate_left()
func on_rotate_right_pressed():
	if FoodTruck.current_selection:
		beep_sound.play()
		FoodTruck.current_selection.rotate_right()
func on_flip_horizontal_pressed():
	if FoodTruck.current_selection:
		beep_sound.play()
		FoodTruck.current_selection.flip_horizontal()
func on_flip_vertical_pressed():
	if FoodTruck.current_selection:
		beep_sound.play()
		FoodTruck.current_selection.flip_vertical()

###############################################################################
## Menu / UI Buttons ##########################################################
###############################################################################
func _on_home_button_pressed() -> void:
	FoodTruck.free_play = false
	back_sound.play()
	SceneManager.change_scene("res://scenes/main_menu.tscn")
func _on_settings_button_pressed() -> void:
	if !settings_menu.menu_open:
		settings_menu.anim_player.play("open_settings_menu")
	else:
		settings_menu.anim_player.play("close_settings_menu")
	settings_menu.menu_open = !settings_menu.menu_open
	beep_sound.play()

func _on_close_button_pressed() -> void:
	next_sound.play()
	# Clear existing toppings from the scene
	clear_pizza_toppings()
	# Enable the bell
	bell.bell_area.disabled = false
	
	# Hide Shutter Menu
	shutter_menu.anim_player.play("shutter_open")
	shutter_close_button.visible = false
	
	# New customer
	customer.random_customer()
	customer.anim_player.play("walk_in")
	await customer.anim_player.animation_finished
	
	# Generate new order and update labels
	FoodTruck.generate_pizza_order()
	speech_bubble.display_order(FoodTruck.desired_toppings)
	shutter_menu.order.text = FoodTruck.current_order
func _on_reset_button_free_play_pressed() -> void:
	clear_pizza_toppings()
	next_sound.play()
