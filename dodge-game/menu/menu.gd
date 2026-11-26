extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var best_label: Label = $VBoxContainer/BestLabel


func _ready() -> void:
	play_button.pressed.connect(GameManager.start_game)
	best_label.text = "Best: %d\nHighest Level: %d" % [GameManager.best_score, GameManager.best_level]
	play_button.grab_focus()
