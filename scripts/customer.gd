extends Node2D

@onready var customer_sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

var number_of_customers = 7
var current_customer: String

func random_customer():
	var new_index := randi_range(1, number_of_customers)
	
	# Prevent repeating the current customer
	while "Customer%d" % new_index == current_customer and number_of_customers > 1:
		new_index = randi_range(1, number_of_customers)
		
	current_customer = "Customer%d" % new_index
	var path = "res://assets/images/customers/%s.png" % current_customer
	
	if ResourceLoader.exists(path):
		customer_sprite.texture = load(path)
	else:
		push_error("Missing customer image at path: " + path)
