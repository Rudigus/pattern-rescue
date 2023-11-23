class_name PatternButton
extends StaticBody3D

@export var albedo_color: Color
@export var color_name: String

@onready var mesh_instance = $MeshInstance

func _ready():
	mesh_instance.set_surface_override_material(0, \
				mesh_instance.get_surface_override_material(0).duplicate())
	mesh_instance.get_surface_override_material(0).albedo_color = albedo_color

func handle_press(color):
	if color == color_name:
		pass
