extends Control

@onready var timer_label = $MarginContainer/VBoxContainer/HBoxContainer/NinePatchRect/TimerLabel
@onready var beep_sound = $Beep_Sound
@onready var play_sound = $Play_Sound


var total_time = 300  # time in seconds, default 5 minute
const MIN_TIME = 30   # 30 seconds
const MAX_TIME = 600  # 10 minutes

func _on_play_button_pressed() -> void:
	play_sound.play()
	SceneManager.game_time_secs = get_time_from_label()
	SceneManager.change_scene("res://scenes/the_food_truck.tscn")

func _on_freeplay_button_pressed() -> void:
	play_sound.play()
	FoodTruck.free_play = true
	SceneManager.change_scene("res://scenes/the_food_truck.tscn")

func _on_increase_button_pressed():
	total_time += 30
	total_time = clamp(total_time, MIN_TIME, MAX_TIME)
	update_timer_label()
	beep_sound.play()

func _on_decrease_button_pressed():
	total_time -= 30
	total_time = clamp(total_time, MIN_TIME, MAX_TIME)
	update_timer_label()
	beep_sound.play()

func update_timer_label():
	var minutes = total_time / 60
	var seconds = total_time % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func get_time_from_label() -> int:
	var time_text = timer_label.text
	var parts = time_text.split(":")
	if parts.size() == 2:
		var minutes = int(parts[0])
		var seconds = int(parts[1])
		return minutes * 60 + seconds
	else:
		push_error("Invalid time format in label!")
		return 0


func _on_quit_button_pressed():
	if Engine.has_singleton("JavaScript"):
		var js = JavaScriptBridge
		js.eval("history.back();")
	else:
		get_tree().quit()
