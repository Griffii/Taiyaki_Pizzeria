extends Node2D

@onready var animation_player_green = $AnimationPlayerGreen
@onready var animation_player_red = $AnimationPlayerRed
@onready var shutter_menu = $"../../Shutter_Menu"

@onready var register_display = $Label
@onready var chime_up = $Audio_ChimeUp

var money_total : float

func _ready():
	shutter_menu.correct_topping.connect(correct_topping)
	shutter_menu.wrong_topping.connect(wrong_topping)
	shutter_menu.missing_topping.connect(missing_topping)
	shutter_menu.correct_amount.connect(correct_amount)
	shutter_menu.wrong_amount.connect(wrong_amount)

func update_display():
	if money_total >= 0.0:
		register_display.text = "$%.2f" % money_total
	else:
		register_display.text = "-$%.2f" % abs(money_total)
	
	# Update global var as well
	FoodTruck.current_cash = money_total

## Cash up / down functions
func correct_topping():
	animation_player_green.play("dollar_green")
	money_total += 1
	update_display()
	chime_up.play()

func correct_amount():
	animation_player_green.play("dollar_green")
	money_total += 0.25
	update_display()
	chime_up.play()

func wrong_topping():
	animation_player_red.play("dollar_red")
	money_total -= 0.75
	update_display()
	chime_up.play()

func wrong_amount():
	animation_player_red.play("dollar_red")
	money_total -= 0.25
	update_display()
	chime_up.play()

func missing_topping():
	animation_player_red.play("dollar_red")
	money_total -= 0.5
	update_display()
	chime_up.play()

func tip_revealed():
	animation_player_red.play("dollar_red")
	money_total -= 0.5
	update_display()
	chime_up.play()
