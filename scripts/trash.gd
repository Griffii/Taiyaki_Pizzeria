extends Node2D

func _on_area_entered(body) -> void:
	if body.get_parent().is_in_group("ingredients"):
		body.get_parent().in_trash = true

func _on_area_exited(body) -> void:
	if body.get_parent().is_in_group("ingredients"):
		body.get_parent().in_trash = false



func _on_area_2d_mouse_entered() -> void:
	$Trash_open.visible = true
	$Trash_Closed.visible = false

func _on_area_2d_mouse_exited() -> void:
	$Trash_open.visible = false
	$Trash_Closed.visible = true
