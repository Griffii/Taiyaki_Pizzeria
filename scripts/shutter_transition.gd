extends Node

@onready var animation_player = $AnimationPlayer

signal shutter_closed
signal shutter_opened

func play_shutter_close():
	animation_player.play("close")
	await animation_player.animation_finished
	emit_signal("shutter_closed")

func play_shutter_open():
	animation_player.play("open")
	await animation_player.animation_finished
	emit_signal("shutter_opened")
