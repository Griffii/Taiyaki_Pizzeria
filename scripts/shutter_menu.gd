extends Control

@export var food_summary_block : PackedScene

@onready var toppingRow1 = $MainMarginContainer/MainVBox/ToppingsMarginContainer/ToppingsVBox/ToppingRow1
@onready var toppingRow2 = $MainMarginContainer/MainVBox/ToppingsMarginContainer/ToppingsVBox/ToppingRow2

func _process(_delta: float) -> void:
	populate_food_summary()

func populate_food_summary():
	# Clear previous summary blocks
	for child in toppingRow1.get_children():
		child.queue_free()
	for child in toppingRow2.get_children():
		child.queue_free()

	# Loop with index
	for i in FoodTruck.pizza_toppings.size():
		var topping = FoodTruck.pizza_toppings[i]
		var block = food_summary_block.instantiate()
		
		if i < 6:
			toppingRow1.add_child(block)
		else:
			toppingRow2.add_child(block)
		
		block.set_icon_and_amount(topping["name"], topping["count"])
