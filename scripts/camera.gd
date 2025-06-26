extends Camera2D

@export var edge_margin := 50          # Pixels from screen edge to trigger movement
@export var scroll_speed := 500.0      # Pixels per second


func _process(_delta):
	#camera_edge_movement(delta)
	pass


func camera_edge_movement(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport_rect().size
	var new_position = global_position
	
	if mouse_pos.y < edge_margin:
		# Move up
		new_position.y -= scroll_speed * delta
	elif mouse_pos.y > screen_size.y - edge_margin:
		# Move down
		new_position.y += scroll_speed * delta
	
	global_position = new_position
