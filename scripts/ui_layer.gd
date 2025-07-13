extends CanvasLayer

@onready var up_button = $MarginContainer/Up_Button
@onready var down_button = $MarginContainer/Down_Button
@onready var camera = $"../Camera"

func _ready() -> void:
	# Turn off up button
	up_button.disabled = true
	up_button.visible = false
	
	if FoodTruck.free_play:
		camera.position = Vector2(960, 1365)
		down_button.disabled = true
		down_button.visible = false

func toggle(button):
	button.visible = !button.visible
	button.disabled = !button.disabled

func move_camera_up():
	toggle(up_button)
	camera.position = Vector2(960, 535)
	toggle(down_button)

func move_camera_down():
	toggle(down_button)
	camera.position = Vector2(960, 1365)
	toggle(up_button)


func _on_up_button_pressed() -> void:
	move_camera_up()
func _on_down_button_pressed() -> void:
	move_camera_down()
