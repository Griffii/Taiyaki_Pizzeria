extends Node


var pizza_mode = true
var free_play = false
var hard_mode = false

# Stores the data for the currently selected ingredient sprite
var current_selection : Node2D

# Toggles when bell is rang - triggers counting of the toppings
var pizza_ready : bool = false

# Stores the order of the current customer as a String
var current_order : String
var desired_toppings : Array

# Stores the toppings on the pizza here when the bell is rang
var pizza_toppings : Array
# Stores the compared results of the desired versus actual pizza toppings
var pizza_check_results : Array

# Store time limit for current game in seconds and how many toppings can be ordered per ingredient
var game_time: int
var max_toppings_allowed: int = 10

#Store a running total of the current cash as a float
var current_cash: float

###############################################################################
## Generates a random pizza order #############################################
###############################################################################
func generate_pizza_order():
	var all_ingredients = []
	
	var all_pizza_toppings = [
		"cabbage", "carrot", "corn", "cucumber", "green pepper",
		"mushroom", "onion", "pepperoni", "potato", "tomato", "pineapple"
	]
	
	var all_parfait_toppings = [
		"pineapple", "peach", "melon", "banana", "apple", "cherry", 
		"strawberry", "orange", "kiwi fruit"
	]
	
	if FoodTruck.pizza_mode:
		all_ingredients = all_pizza_toppings
	else:
		all_ingredients = all_parfait_toppings
	
	var order_parts: Array = []
	var new_toppings: Array = []
	
	# Add cheese for pizzas, ice cream for parfaits
	if FoodTruck.pizza_mode:
		# Add cheese randomly
		var has_cheese = randi() % 2 == 0
		if has_cheese:
			order_parts.append("cheese")
			new_toppings.append({ "name": "cheese", "count": 99 })
	else:
		# Randomly determine which ice cream types are requested (1–3 total, repeats not allowed)
		var ice_cream_types = ["vanilla ice cream", "chocolate ice cream", "strawberry ice cream"]
		var selected_flavors = []
		
		for flavor in ice_cream_types:
			if randi() % 2 == 0:
				selected_flavors.append(flavor)
		
		# Ensure at least one flavor is selected
		if selected_flavors.is_empty():
			selected_flavors.append(ice_cream_types[randi() % ice_cream_types.size()])
		
		for flavor in selected_flavors:
			order_parts.append(flavor)
			new_toppings.append({ "name": flavor, "count": 99 })
	
	# Shuffle and pick a few toppings (1–4 random types)
	all_ingredients.shuffle()
	var num_toppings = randi() % 4 + 1
	
	for i in range(num_toppings):
		var ingredient = all_ingredients[i]
		# Set the count based off of the max_toppings_allowed setting
		var count = randi() % max_toppings_allowed + 1 
		new_toppings.append({ "name": ingredient, "count": count })
		order_parts.append(num_to_words(count) + " " + pluralize(ingredient, count))
	
	# Join the order string nicely
	var order_string: String
	
	if FoodTruck.pizza_mode:
		order_string = "Can I get a pizza with "
	else:
		order_string = "Can I get a parfait with "
	
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
		# Veggie exceptions
		if word == "corn":
			return word # Don't pluralize corn
		if word == "tomato":
			return word + "es"
		if word == "potato":
			return word + "es"
		# Fruit exceptions
		if word == "strawberry":
			return "strawberries"
		if word == "cherry":
			return "cherries"
		if word == "peach":
			return word + "es"
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
