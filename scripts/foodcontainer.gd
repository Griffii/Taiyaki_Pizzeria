extends Node2D

class_name FoodContainer

@export var food_scene: PackedScene
@export var food_type : String

@onready var pizza_toppings_container = %PizzaToppings
@onready var area = $Area2D

func _ready() -> void:
	area.connect("mouse_entered", Callable(self, "_on_area_2d_mouse_entered"))
	area.connect("mouse_exited", Callable(self, "_on_area_2d_mouse_exited"))
	area.connect("input_event", Callable(self, "_on_area_2d_input_event"))


func spawn_food():
	if food_scene:
		var food = food_scene.instantiate()
		
		# Get mouse position
		var mouse_pos = get_global_mouse_position()
		
		# Try to find the sprite in the food node
		var sprite := food.get_node_or_null("Sprite2D")
		if sprite and sprite.texture:
			var tex_size = sprite.texture.get_size() * sprite.scale
			food.position = mouse_pos - (tex_size / 2)
		else:
			# Fallback: no sprite or texture found, just place directly
			food.position = mouse_pos
		
		food.type = food_type
		pizza_toppings_container.add_child(food)

func _on_area_2d_mouse_entered() -> void:
	for child in $Ingredients.get_children():
		if child is Sprite2D:
			child.modulate = Color(1.5, 1.5, 1.5, 1.0)

func _on_area_2d_mouse_exited() -> void:
	for child in $Ingredients.get_children():
		if child is Sprite2D:
			child.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		spawn_food()
