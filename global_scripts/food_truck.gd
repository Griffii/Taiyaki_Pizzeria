extends Node

# Stores the data for the currently selected ingredient sprite
var current_selection : Node2D

# Toggles when bell is rang - triggers counting of the toppings
var pizza_ready : bool = false

# Stores the toppings on the pizza here when the bell is rang
var pizza_toppings : Array

# Stores the order of the current customer as a String
var current_order : String
var desired_toppings : Array

# Stores the compared results of the desired versus actual pizza toppings
var pizza_check_results : Array


###############################################################################
## Generates a random pizza order #############################################
###############################################################################
func generate_pizza_order():
	var all_ingredients = [
		"cabbage", "carrot", "corn", "cucumber", "green pepper",
		"mushroom", "onion", "pepperoni", "potatoe", "tomatoe", "pineapple"
	]
	
	var order_parts: Array = []
	var new_toppings: Array = []
	
	# Randomly decide if cheese is included
	var has_cheese = randi() % 2 == 0
	if has_cheese:
		order_parts.append("cheese")
		new_toppings.append({ "name": "cheese", "count": 1 })
		
	# Shuffle and pick a few toppings (1–4 random types)
	all_ingredients.shuffle()
	var num_toppings = randi() % 4 + 1
	
	for i in range(num_toppings):
		var ingredient = all_ingredients[i]
		var count = randi() % 10 + 1 # 11-20 is to annoying, will adda  ahrd setting later
		new_toppings.append({ "name": ingredient, "count": count })
		order_parts.append(num_to_words(count) + " " + pluralize(ingredient, count))
		
	# Join the order string nicely
	var order_string = "Can I get a pizza with "
	order_string += join_ingredients(order_parts) + "?"
	
	# Save to global state
	current_order = order_string
	desired_toppings = new_toppings

# Helper functions for generate_pizza_order()
func pluralize(word: String, count: int) -> String:
	if count == 1:
		return word
	else:
		if word.ends_with("s"):
			return word  # already plural, like "pepperonis"
		if word == "corn":
			return word # Don't pluralize corn
		return word + "s"

func join_ingredients(parts: Array) -> String:
	if parts.size() == 1:
		return parts[0]
	elif parts.size() == 2:
		return parts[0] + " and " + parts[1]
	else:
		return ", ".join(parts.slice(0, parts.size() - 1)) + ", and " + parts[-1]

func num_to_words(n: int) -> String:
	var nums = [
		"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
		"eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"
	]
	return nums[n] if n <= 20 else str(n)
