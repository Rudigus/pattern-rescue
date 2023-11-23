extends Node3D

@onready var buttons = $Buttons
@onready var player = $Player
@onready var pattern_manager = $PatternManager
@onready var lost_game_panel = $LostGamePanel
@onready var won_game_panel = $WonGamePanel

const HelperScene = preload("res://helper.tscn")

var helpers: Array[Helper] = []

func _ready():
	for button in buttons.get_children():
		player.button_pressed.connect(button.handle_press)
	player.button_pressed.connect(pattern_manager.handle_press)
	
func find_button(color: PatternManager.PatternColor) -> PatternButton:
	var color_name: String
	match color:
		PatternManager.PatternColor.RED:
			color_name = "red"
		PatternManager.PatternColor.BLUE:
			color_name = "blue"
		PatternManager.PatternColor.GREEN:
			color_name = "green"
		PatternManager.PatternColor.YELLOW:
			color_name = "yellow"
	for button in buttons.get_children():
		if button.color_name == color_name:
			return button
	return PatternButton.new()

func _on_pattern_manager_game_lost():
	lost_game_panel.visible = true

func _on_pattern_manager_game_won():
	won_game_panel.visible = true

func _on_pattern_manager_should_replay():
	player.mesh_instance.get_surface_override_material(0).albedo_color = Color("7400ff") \
	.darkened(0.75)
	var pattern = pattern_manager.color_pattern
	for color in pattern:
		var button = find_button(color)
		button.animate_pressed()
		await get_tree().create_timer(1).timeout
	pattern_manager.replay_finished()
	player.mesh_instance.get_surface_override_material(0).albedo_color = Color("7400ff")

func spawn_helper(color: PatternManager.PatternColor):
	player.position = Vector3(0, 1, 0)
	var helper = HelperScene.instantiate()
	var helper_button = find_button(color)
	helper.position = helper_button.position + Vector3(0, 1, 0)
	helper.assigned_color = color
	helper.button_pressed.connect(helper_button.handle_press)
	helper.button_pressed.connect(pattern_manager.handle_press)
	add_child(helper)
	helpers.append(helper)

func _on_pattern_manager_helper_should_jump(color):
	for helper in helpers:
		if helper.assigned_color == color:
			helper.jump()
