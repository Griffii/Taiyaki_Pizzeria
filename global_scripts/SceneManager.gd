extends Node

var current_scene: Node = null
var shutter: Node = null

var game_time_secs: int

func _ready() -> void:
	await get_tree().process_frame
	shutter = preload("res://scenes/UI/shutter_transition.tscn").instantiate()
	get_tree().root.add_child(shutter)
	shutter.animation_player.play("open")
	
	current_scene = get_tree().root.get_node("MainMenu")


func change_scene(path: String):
	await shutter.play_shutter_close()
	
	# Free the old scene
	if current_scene:
		current_scene.queue_free()
	
	# Load the new scene
	var new_scene = load(path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene
	
	await shutter.play_shutter_open()
	
	if current_scene.has_method("set_timer") and !FoodTruck.free_play:
		current_scene.set_timer(game_time_secs)
