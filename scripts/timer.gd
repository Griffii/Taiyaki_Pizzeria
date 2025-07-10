extends Node2D

@onready var timer_label = $Label
@onready var countdown_timer = $Timer

var time_left := 0  # in seconds

func _ready():
	countdown_timer.timeout.connect(_on_CountdownTimer_timeout)
	
	start_timer(5)

func start_timer(minutes: int):
	time_left = minutes * 60
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
	print("Time's up!")
