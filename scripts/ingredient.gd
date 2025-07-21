class_name Ingredient
extends Sprite2D

@onready var area: Area2D = $Area2D
@onready var input_blocker: Control = $Control
@onready var sfx = $SFX

@export var type : String

var dragging = false
var drag_offset = Vector2.ZERO
var in_trash = false
var locked = false
var can_sfx = true


func _ready() -> void:
	# Spawn dragging
	dragging = true
	drag_offset = get_global_mouse_position() - global_position
	raise_to_top()
	
	# Set as current selection in the root node
	FoodTruck.current_selection = self
	
	# Increase volume of sfx
	sfx.volume_db = 16.0
	
	#offset = texture.get_size() / 2



func _process(_delta: float) -> void:
	if dragging and !locked:
		global_position = get_global_mouse_position() - drag_offset
	
	if !Input.is_action_pressed("click"):
		dragging = false
	
	if in_trash and !dragging:
		delete()
	
	# Make a sound when dropped, but only once
	if !dragging and can_sfx:
		sfx.play()
		can_sfx = false

func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		dragging = true
		can_sfx = true
		drag_offset = get_global_mouse_position() - global_position
		
		FoodTruck.current_selection = self # Set as current selection when clicked
		if !locked: # Move to top layer only if unlocked
			raise_to_top() 
		
		# This stops the user from spawning more toppings if clicking above a container
		input_blocker.accept_event() 

func raise_to_top():
	var parent = get_parent()
	if parent == null:
		return
	
	var highest_z = -INF
	for child in parent.get_children():
		if child is Node2D and child != self:
			if child.has_method("get_z_index"):  # Safely check z_index
				highest_z = max(highest_z, child.z_index)
	
	var new_z = highest_z + 1
	z_index = new_z  # Raise self
	
	# Also raise the control and/or area2D if they exist
	if has_node("Control"):
		get_node("Control").z_index = new_z
	if has_node("Area2D"):
		get_node("Area2D").z_index = new_z

func delete():
	queue_free()
	FoodTruck.current_selection = null

func rotate_left():
	rotation += deg_to_rad(-20)
	#input_blocker.rotation += deg_to_rad(-20)

func rotate_right():
	rotation += deg_to_rad(20)
	#input_blocker.rotation += deg_to_rad(20)

func flip_horizontal():
	flip_h = !flip_h
	#var current_scale_x = scale.x
	#scale.x = -current_scale_x

func flip_vertical():
	flip_v = !flip_v
	#var current_scale_y = scale.y
	#scale.y = -current_scale_y
