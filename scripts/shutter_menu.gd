extends Control

@export var food_summary_block : PackedScene

@onready var anim_player = $AnimationPlayer
@onready var toppingRow1 = $MainMarginContainer/MainVBox/ToppingsMarginContainer/ToppingsVBox/ToppingRow1
@onready var toppingRow2 = $MainMarginContainer/MainVBox/ToppingsMarginContainer/ToppingsVBox/ToppingRow2
@onready var order = $MainMarginContainer/MainVBox/OrderContainer/The_Order

signal correct_topping
signal wrong_topping
signal missing_topping
signal correct_amount
signal wrong_amount

var used_toppings : Array = []

func populate_food_summary():
	# Clear previous summary blocks
	for child in toppingRow1.get_children():
		child.queue_free()
	for child in toppingRow2.get_children():
		child.queue_free()
		
	await get_tree().create_timer(1.5).timeout  # Wait for shutter
	
	used_toppings.clear()
	
	for i in FoodTruck.pizza_check_results.size():
		var topping = FoodTruck.pizza_check_results[i]
		var block = food_summary_block.instantiate()
		
		# Add to correct row
		if i < 6:
			toppingRow1.add_child(block)
		else:
			toppingRow2.add_child(block)
			
		block.set_icon_and_amount(
			topping["name"],
			topping["name_correct"],
			topping["count"],
			topping["count_correct"]
		)
		
		var name = topping["name"]
		var name_correct = topping["name_correct"]
		var count = topping["count"]
		var count_correct = topping["count_correct"]
		var expected_count = topping["expected_count"]
		
		# Track used toppings (case-insensitive)
		used_toppings.append(name)
		
		if name_correct and count > 0:
			#print("✅ Signal: correct_topping for '%s'" % name)
			emit_signal("correct_topping")
		elif not name_correct:
			#print("❌ Signal: wrong_topping for '%s'" % name)
			emit_signal("wrong_topping")
			await get_tree().create_timer(1).timeout
			continue  # Skip further checks
			
		# Count-based evaluation (for correct toppings only)
		var correct_amt = count_correct
		var wrong_amt = abs(expected_count - count)
		
		for y in correct_amt:
			#print("✅ Signal: correct_amount for '%s'" % name)
			emit_signal("correct_amount")
			await get_tree().create_timer(0.05).timeout
		for z in wrong_amt:
			#print("❌ Signal: wrong_amount for '%s' (extra or missing)" % name)
			emit_signal("wrong_amount")
			await get_tree().create_timer(0.05).timeout
		
		# Handle missing topping case
		if name_correct and count == 0:
			#print("❌ Signal: missing_topping for '%s'" % name)
			emit_signal("missing_topping")
			await get_tree().create_timer(0.05).timeout
		
		await get_tree().create_timer(1).timeout
