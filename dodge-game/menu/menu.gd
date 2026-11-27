extends Control

const LOGIN_ICON: Texture2D = preload("res://assets/icons/log-in.svg")
const LOGOUT_ICON: Texture2D = preload("res://assets/icons/log-out.svg")

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var user_label: Label = $VBoxContainer/UserLabel
@onready var best_label: Label = $VBoxContainer/BestLabel
@onready var account_button: TextureButton = $AccountButton


func _ready() -> void:
	play_button.pressed.connect(GameManager.start_game)
	account_button.pressed.connect(_on_account_pressed)
	_refresh()
	play_button.grab_focus()
	if await Api.restore():
		_refresh()


func _refresh() -> void:
	account_button.texture_normal = LOGIN_ICON if Api.user.is_empty() else LOGOUT_ICON
	user_label.text = "Player: %s" % Api.user.get("name", "Guest")
	best_label.text = "Best: %d\nHighest Level: %d" % [GameManager.best_score, GameManager.best_level]


func _on_account_pressed() -> void:
	if Api.user.is_empty():
		GameManager.go_to_auth()
	else:
		Api.logout()
