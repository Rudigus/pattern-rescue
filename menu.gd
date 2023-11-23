extends Control

const WorldScene = preload("res://world.tscn")

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(WorldScene)
