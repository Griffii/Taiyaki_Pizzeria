extends Control

# Labels and Buttons
@onready var hard_mode_button = %HardMode_Button
@onready var hard_mode_setting_label = %HardMode_Setting_Label
@onready var max_toppings = %"Topping#_Selection_Label"

@onready var volume_slider = $Border_Box/MarginContainer/VBoxContainer/Sound_VBox/HBoxContainer/SFX_Slider

@onready var anim_player = $AnimationPlayer
var menu_open = false

# Sounds
@onready var beep_sound = $Beep_Sound
@onready var click_sound = $Click_Sound

func _ready() -> void:
	# Set Hard Mode Label
	if FoodTruck.hard_mode:
		hard_mode_setting_label.text = "ON"
		hard_mode_button.button_pressed = true
	else:
		hard_mode_setting_label.text = "OFF"
		hard_mode_button.button_pressed = false
	
	max_toppings.text = str(FoodTruck.max_toppings_allowed)


func max_toppings_up():
	var topping_amount = int(max_toppings.text)
	if topping_amount < 20:
		topping_amount += 1
		max_toppings.text = str(topping_amount)
		FoodTruck.max_toppings_allowed = topping_amount
		click_sound.play()
func max_toppings_down():
	var topping_amount = int(max_toppings.text)
	if topping_amount > 1:
		topping_amount -= 1
		max_toppings.text = str(topping_amount)
		FoodTruck.max_toppings_allowed = topping_amount
		click_sound.play()

func hard_mode_toggle():
	FoodTruck.hard_mode = !FoodTruck.hard_mode
	click_sound.play()
	# Switch the text on the button
	if hard_mode_setting_label.text == "ON":
		hard_mode_setting_label.text = "OFF"
	else:
		hard_mode_setting_label.text = "ON"


func _close_button_pressed() -> void:
	anim_player.play("close_settings_menu")
	menu_open = false
	beep_sound.play()


func _on_mute_button_pressed() -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	var is_muted = AudioServer.is_bus_mute(bus_index)
	AudioServer.set_bus_mute(bus_index, !is_muted)
	volume_slider.editable = !volume_slider.editable
	beep_sound.play()
