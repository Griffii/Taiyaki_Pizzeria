extends Button

@onready var locked_icon = $Locked
@onready var unlocked_icon = $Unlocked
@onready var no_selection_icon = $NoSelection
@onready var lock_sfx = $Lock_SFX

var current_icon

func _process(_delta: float) -> void:
	if FoodTruck.current_selection:
		if FoodTruck.current_selection.locked:
			locked_icon.visible = true
			unlocked_icon.visible = false
			no_selection_icon.visible = false
			
			current_icon = locked_icon
		else:
			locked_icon.visible = false
			unlocked_icon.visible = true
			no_selection_icon.visible = false
			
			current_icon = unlocked_icon
	else:
		unlocked_icon.visible = false
		locked_icon.visible = false
		no_selection_icon.visible = true
		
		current_icon = no_selection_icon


func _on_mouse_entered() -> void:
	current_icon.scale = Vector2(1.2, 1.2)

func _on_mouse_exited() -> void:
	current_icon.scale = Vector2(1.0, 1.0)

# Lock the current selection
func _on_pressed() -> void:
	if FoodTruck.current_selection:
		lock_sfx.play()
		FoodTruck.current_selection.locked = !FoodTruck.current_selection.locked
