extends Node2D

@onready var bell_sprite = $Sprite2D

signal bell_pressed


func _on_area_2d_mouse_entered() -> void:
	bell_sprite.material.set_shader_parameter("glow_enabled", true)
func _on_area_2d_mouse_exited() -> void:
	bell_sprite.material.set_shader_parameter("glow_enabled", false)



func _on_bell_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		bell_pressed.emit()
		
		bell_sprite.scale = Vector2(1.0, 0.8)
		await get_tree().create_timer(0.1).timeout
		bell_sprite.scale = Vector2(1.0, 1.0)
		
		# Play bell sound
		
		
