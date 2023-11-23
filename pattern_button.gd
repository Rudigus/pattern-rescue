class_name PatternButton
extends StaticBody3D

@export var albedo_color: Color
@export var color_name: String

@onready var mesh_instance = $MeshInstance
@onready var pattern_manager = get_node("../../PatternManager")

func _ready():
	mesh_instance.set_surface_override_material(0, \
				mesh_instance.get_surface_override_material(0).duplicate())
	mesh_instance.get_surface_override_material(0).albedo_color = albedo_color.darkened(0.75)

func handle_press(color):
	if pattern_manager.is_on_replay:
		return
	if color == color_name:
		animate_pressed()

func animate_pressed():
	mesh_instance.get_surface_override_material(0).albedo_color = albedo_color
	await get_tree().create_timer(0.5).timeout
	mesh_instance.get_surface_override_material(0).albedo_color = albedo_color.darkened(0.75)
