extends Label

@export var default_tip_texture: TextureRect
var revealed_tip_texture: TextureRect

@onready var area_2d: Area2D = $Area2D
@onready var shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var tooltip_box: NinePatchRect = $TooltipBox
@onready var tooltip_texture: TextureRect = $TooltipBox/Texture 
@onready var tooltip_label: Label = $TooltipBox/Label
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var reveal_sfx = $AudioStreamPlayer2D

var base_color := Color.WHITE
var revealed := false

# Sizes for tooltip
const HINT_HIDDEN_SIZE := Vector2(64, 64)
const HINT_REVEALED_SIZE := Vector2(128, 128)  

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	randomize_color()
	update_collision_shape()
	
	tooltip_box.visible = false
	tooltip_box.size = HINT_HIDDEN_SIZE
	tooltip_texture = default_tip_texture
	tooltip_label.text = ""
	
	position_tooltip_box()
	
	area_2d.mouse_entered.connect(_on_mouse_entered)
	area_2d.mouse_exited.connect(_on_mouse_exited)
	area_2d.input_event.connect(_on_input_event)


func randomize_color():
	var hue = randf()  # full color wheel
	var saturation = randf_range(0.9, 1.0)
	var value = randf_range(0.5, 0.9)
	
	# Avoid hues near yellow (low contrast on white)
	if hue > 0.12 and hue < 0.18:
		hue = fmod(hue + 0.2, 1.0)
	
	base_color = Color.from_hsv(hue, saturation, value)
	add_theme_color_override("font_color", base_color)





func update_collision_shape():
	await get_tree().process_frame
	var shape_extents = size / 2
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = shape_extents
	shape.shape = rect_shape
	area_2d.position = shape_extents

func position_tooltip_box():
	# Center the tooltip box above the label
	tooltip_box.position = Vector2(
		size.x / 2 - tooltip_box.size.x / 2,
		-tooltip_box.size.y - 5
	)
	
	# Resize and center the texture inside the tooltip box
	tooltip_texture.size = tooltip_box.size
	tooltip_texture.position = Vector2.ZERO
	
	# Resize and center the label
	tooltip_label.size = tooltip_box.size
	tooltip_label.position = Vector2.ZERO
	tooltip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tooltip_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER


func _on_mouse_entered():
	add_theme_color_override("font_color", base_color.lightened(0.5))
	if !revealed:
		tooltip_box.size = HINT_HIDDEN_SIZE
		tooltip_texture = default_tip_texture
	else:
		tooltip_box.size = HINT_REVEALED_SIZE
	
	position_tooltip_box()
	tooltip_box.visible = true
	anim.play("hover_in")

func _on_mouse_exited():
	add_theme_color_override("font_color", base_color)
	scale = Vector2.ONE
	anim.play("hover_out")
	# Wait for the animation to finish before continuing
	var finished = await anim.animation_finished
	if finished == "hover_out":
		tooltip_box.visible = false

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		scale = Vector2(0.95, 0.95)
		await get_tree().create_timer(0.1).timeout
		scale = Vector2.ONE
		_reveal_tooltip()

func _reveal_tooltip():
	if revealed:
		return
	revealed = true
	reveal_sfx.play()
	tooltip_box.size = HINT_REVEALED_SIZE
	setup_revealed_tip()
	position_tooltip_box()

func setup_revealed_tip():
	var word = text.strip_edges().to_lower()
	var tooltip_label_node = tooltip_label
	var tooltip_texture_node = tooltip_texture
	
	var number_words := {
		"one": 1, "two": 2, "three": 3, "four": 4, "five": 5,
		"six": 6, "seven": 7, "eight": 8, "nine": 9, "ten": 10,
		"eleven": 11, "twelve": 12, "thirteen": 13, "fourteen": 14,
		"fifteen": 15, "sixteen": 16, "seventeen": 17, "eighteen": 18,
		"nineteen": 19, "twenty": 20
	}
	
	# Reset both visibility
	tooltip_label_node.visible = false
	tooltip_texture_node.visible = false
	
	if number_words.has(word):
		tooltip_label_node.text = str(number_words[word])
		tooltip_label_node.visible = true
	else:
		# Convert plural to singular (naive, works for simple s-endings)
		if word.ends_with("s") and not word.ends_with("ss"):
			word = word.substr(0, word.length() - 1)
			
		var image_name = word.capitalize() + ".png"
		var path = "res://assets/images/ingredients/" + image_name
		if ResourceLoader.exists(path):
			var tex = load(path)
			tooltip_texture_node.texture = tex
			tooltip_texture_node.visible = true
		else:
			tooltip_label_node.text = "?"
			tooltip_label_node.visible = true
