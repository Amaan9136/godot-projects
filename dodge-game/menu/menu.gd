extends Control

const LOGIN_ICON: Texture2D = preload("res://assets/icons/log-in.svg")
const LOGOUT_ICON: Texture2D = preload("res://assets/icons/log-out.svg")

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var leaderboard_button: TextureButton = $LeaderboardButton
@onready var user_label: Label = $VBoxContainer/UserLabel
@onready var best_label: Label = $VBoxContainer/BestLabel
@onready var account_button: TextureButton = $AccountButton
@onready var settings_button: TextureButton = $SettingsButton


func _ready() -> void:
	play_button.pressed.connect(GameManager.start_game)
	account_button.pressed.connect(_on_account_pressed)
	leaderboard_button.pressed.connect(GameManager.go_to_leaderboard)
	settings_button.pressed.connect(GameManager.go_to_settings)
	_refresh()
	_animate_in()
	play_button.grab_focus()
	if await Api.restore():
		_refresh()


func _process(_delta: float) -> void:
	var time: float = Time.get_ticks_msec() / 1000.0
	_pulse(title_label, 0.05 * sin(time * 2.0))
	_pulse(play_button, 0.04 * sin(time * 4.0))


func _pulse(target: Control, amount: float) -> void:
	target.pivot_offset = target.size / 2.0
	target.scale = Vector2.ONE * (1.0 + amount)


func _animate_in() -> void:
	for item: Control in $VBoxContainer.get_children():
		item.modulate.a = 0.0
		create_tween().tween_property(item, "modulate:a", 1.0, 0.5).set_delay(item.get_index() * 0.15)


func _refresh() -> void:
	account_button.texture_normal = LOGIN_ICON if Api.user.is_empty() else LOGOUT_ICON
	user_label.text = "Player: %s" % Api.user.get("name", "Guest")
	best_label.text = "Best: %d\nHighest Level: %d\nBest Time: %.1f s" % [GameManager.best_score, GameManager.best_level, GameManager.best_time]


func _on_account_pressed() -> void:
	if Api.user.is_empty():
		GameManager.go_to_auth()
	else:
		Api.logout()