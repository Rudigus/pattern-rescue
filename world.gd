extends Node3D

@onready var buttons = $Buttons
@onready var player = $Player

func _ready():
	for button in buttons.get_children():
		player.button_pressed.connect(button.handle_press)
