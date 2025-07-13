extends Node2D

@onready var timer_label = $Label
@onready var countdown_timer = $Timer

var time_left: int = 0  # in seconds

func _ready():
	countdown_timer.timeout.connect(_on_CountdownTimer_timeout)


func start_timer(seconds: int):
	time_left = seconds
	update_timer_label()
	countdown_timer.start()

func _on_CountdownTimer_timeout():
	if time_left > 0:
		time_left -= 1
		update_timer_label()
	else:
		countdown_timer.stop()
		on_timer_timeout()

func update_timer_label():
	var minutes = int(time_left / 60)
	var seconds = int(time_left % 60)
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func on_timer_timeout():
	# Load the score screen
	var score_screen_scene = load("res://scenes/UI/score_screen.tscn")
	var score_screen = score_screen_scene.instantiate()

	# Add it to the root viewport
	get_tree().root.add_child(score_screen)
