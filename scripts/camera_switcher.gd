extends Control


@onready var up_button = $MarginContainer/Up_Button
@onready var down_button = $MarginContainer/Down_Button

@onready var camera = $Camera

func _ready() -> void:
	down_button.disabled = true


func move_camera_up():
	up_button.disabled = true
	#Tween camera postion up
	camera.global_position = Vector2(960, 1365)
	down_button.disabled = false

func move_camera_down():
	down_button.disabled = true
	#Tween camera postion down
	camera.global_position = Vector2(960, 535)
	up_button.disabled = false
