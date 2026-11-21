extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton


func _ready() -> void:
	play_button.pressed.connect(GameManager.start_game)
	play_button.grab_focus()
