extends CanvasLayer

@onready var time_label = %Time_Label
@onready var money_label = %Money_Label
@onready var anim_player = $AnimationPlayer


func _ready() -> void:
	# Set the time label from the time limit of the last game
	get_time_from_seconds(FoodTruck.game_time)
	
	# Set the money value of the current money score
	get_score_from_number(FoodTruck.current_cash)
	
	# Animate the window opening
	anim_player.play("open")





func get_time_from_seconds(given_time: int):
	var minutes = int(given_time / 60)
	var seconds = int(given_time % 60)
	time_label.text = "%02d:%02d" % [minutes, seconds]

func get_score_from_number(money_total: float):
	if money_total >= 0.0:
		money_label.text = "$%.2f" % money_total
	else:
		money_label.text = "-$%.2f" % abs(money_total)


func _on_menu_button_pressed() -> void:
	anim_player.play("close")
	await get_tree().create_timer(0.8).timeout
	SceneManager.change_scene("res://scenes/main_menu.tscn")
	
	# Commit suicide
	self.queue_free()

# Eat inputs
func _unhandled_input(event):
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		# If the event wasn't already handled by a UI element, block further propagation
		if !get_viewport().gui_get_focus_owner():
			get_viewport().set_input_as_handled()
