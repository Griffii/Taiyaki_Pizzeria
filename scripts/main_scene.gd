extends Node2D

@onready var debug_label = $DEBUG_CurrentSelection
@onready var lock_button = $UI_Layer/Lock_Button
@onready var pizza_area = $"The_Pizza/PizzaArea"
@onready var bell_button = $"Decorations Container/Bell"

func _ready() -> void:
	bell_button.bell_pressed.connect(check_toppings) # Connect the bell pressed signal

func _process(_delta: float) -> void:
	if FoodTruck.current_selection:
		debug_label.text = str(FoodTruck.current_selection.type)
	else:
		debug_label.text = "No selection"
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_mouse_click(event)

# Sort sprites by Z index when clicking, only pass the event to the top most sprite
func handle_mouse_click(event):
	var mouse_pos = get_global_mouse_position()
	var top_node = null
	var top_z := -INF
	var overlapping := []
	
	for ingredient in get_tree().get_nodes_in_group("ingredients"):
		if not ingredient.has_node("Control"):
			print(ingredient, " has no Control node.")
			continue
			
		var ctrl := ingredient.get_node("Control") as Control
		if not ctrl.visible:
			print(ingredient, " has no visible Control node.")
			continue
			
		if ctrl.get_global_rect().has_point(mouse_pos):
			overlapping.append({"node": ingredient, "z": ctrl.z_index})
			if ctrl.z_index > top_z:
				top_z = ctrl.z_index
				top_node = ingredient
	# Debug: print all overlapping nodes and their z_index values
	if overlapping.size() > 0:
		print("\n--- Overlapping nodes at mouse ---")
		for entry in overlapping:
			print("• ", entry["node"].type, " (z_index: ", entry["z"], ")")
	if top_node:
		print("Top node selected: ", top_node.type)
		if top_node.has_method("_on_area_input_event"):
			top_node._on_area_input_event(null, event, 0)
		else:
			print("[No input management function available] Selected ingredient:", top_node.type)


# Lock selected ingredient in place so it cant move or change z index
func _on_lock_button_pressed() -> void:
	if FoodTruck.current_selection:
		FoodTruck.current_selection.locked = !FoodTruck.current_selection.locked
		print(FoodTruck.current_selection, " is locked: ", FoodTruck.current_selection.locked)


func check_toppings():
	# Store all ingredient nodes in the PizzaToppings container in an array
	var all_toppings: Array = $%PizzaToppings.get_children()
	
	# Check which overlap with the pizza_area (Area2D of the pizza node) and store those in an array
	var toppings_in_pizza_area: Array = []
	
	for topping in all_toppings:
		if topping.has_node("Area2D"):
			var topping_area := topping.get_node("Area2D") as Area2D
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
