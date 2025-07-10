extends CanvasLayer



@onready var up_button = $MarginContainer/Up_Button
@onready var down_button = $MarginContainer/Down_Button
@onready var rotate_left_button = $Rotate_Left
@onready var rotate_right_button = $Rotate_Right
@onready var lock_button = $Lock_Button
@onready var camera = $"../Camera"

func _ready() -> void:
	# Turn off up button
	up_button.disabled = true
	up_button.visible = false
	# Turn off lock button
	lock_button.disabled = true
	lock_button.visible = false
	# Turn off rotate buttons
	rotate_left_button.visible = false
	rotate_left_button.disabled = true
	rotate_right_button.visible = false
	rotate_right_button.disabled = true

func toggle(button):
	button.visible = !button.visible
	button.disabled = !button.disabled

func move_camera_up():
	toggle(down_button)
	toggle(up_button)
	toggle(lock_button)
	toggle(rotate_left_button)
	toggle(rotate_right_button)
	
	camera.position = Vector2(960, 535)
func move_camera_down():
	toggle(down_button)
	toggle(up_button)
	toggle(lock_button)
	toggle(rotate_left_button)
	toggle(rotate_right_button)
	
	camera.position = Vector2(960, 1365)

func _on_up_button_pressed() -> void:
	move_camera_up()
func _on_down_button_pressed() -> void:
	move_camera_down()
