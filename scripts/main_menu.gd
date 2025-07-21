extends Control

@onready var timer_label = %TimerLabel
@onready var beep_sound = $Beep_Sound
@onready var click_sound = $Click_Sound
@onready var play_sound = $Play_Sound

@onready var gray_box = $GrayBox

@onready var park_background = $Background
@onready var beach_background = $Background2
@onready var pizza_logo = $PizzaLogo
@onready var parfait_logo = $ParfaitsLogo
@onready var settings_menu = $Settings_Menu

var settings_open = false

var total_time = 300  # time in seconds, default 5 minute
const MIN_TIME = 30   # 30 seconds
const MAX_TIME = 600  # 10 minutes

func _ready() -> void:
	if FoodTruck.pizza_mode:
		gray_box.position = Vector2(960,0)
	else:
		gray_box.position = Vector2(0,0)

func _on_play_button_pressed() -> void:
	play_sound.play()
	SceneManager.game_time_secs = get_time_from_label()
	if FoodTruck.pizza_mode:
		SceneManager.change_scene("res://scenes/pizza_shop.tscn")
	else:
		SceneManager.change_scene("res://scenes/parfait_shop.tscn")
func _on_freeplay_button_pressed() -> void:
	play_sound.play()
	FoodTruck.free_play = true
	if FoodTruck.pizza_mode:
		SceneManager.change_scene("res://scenes/pizza_shop.tscn")
	else:
		SceneManager.change_scene("res://scenes/parfait_shop.tscn")

func _on_increase_button_pressed():
	total_time += 30
	total_time = clamp(total_time, MIN_TIME, MAX_TIME)
	update_timer_label()
	click_sound.play()
func _on_decrease_button_pressed():
	total_time -= 30
	total_time = clamp(total_time, MIN_TIME, MAX_TIME)
	update_timer_label()
	click_sound.play()

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

func _on_settings_button_pressed():
	if !settings_menu.menu_open:
		settings_menu.anim_player.play("open_settings_menu")
	else:
		settings_menu.anim_player.play("close_settings_menu")
	settings_menu.menu_open = !settings_menu.menu_open
	beep_sound.play()

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func switch_shops():
	FoodTruck.pizza_mode = !FoodTruck.pizza_mode
	beep_sound.play()
	if FoodTruck.pizza_mode:
		gray_box.position = Vector2(960,0)
	else:
		gray_box.position = Vector2(0,0)
