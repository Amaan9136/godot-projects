extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var user_label: Label = $VBoxContainer/UserLabel
@onready var best_label: Label = $VBoxContainer/BestLabel
@onready var account_button: Button = $VBoxContainer/AccountButton


func _ready() -> void:
	play_button.pressed.connect(GameManager.start_game)
	account_button.pressed.connect(Api.logout)
	user_label.text = "Player: %s" % Api.user.get("name", "")
	best_label.text = "Best: %d\nHighest Level: %d" % [GameManager.best_score, GameManager.best_level]
	play_button.grab_focus()
