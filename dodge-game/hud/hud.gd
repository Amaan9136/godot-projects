extends CanvasLayer

const PAUSE_ICON: Texture2D = preload("res://assets/icons/pause.svg")
const PLAY_ICON: Texture2D = preload("res://assets/icons/play.svg")

@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel
@onready var level_label: Label = $LevelLabel
@onready var dim: ColorRect = $Dim
@onready var game_over_panel: VBoxContainer = $GameOverPanel
@onready var final_score_label: Label = $GameOverPanel/FinalScoreLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton
@onready var menu_button: Button = $GameOverPanel/MenuButton
@onready var pause_button: TextureButton = $PauseButton
@onready var pause_panel: VBoxContainer = $PausePanel
@onready var pause_stats_label: Label = $PausePanel/StatsLabel
@onready var resume_button: Button = $PausePanel/ResumeButton
@onready var quit_button: Button = $PausePanel/QuitButton


func _ready() -> void:
	dim.hide()
	game_over_panel.hide()
	pause_panel.hide()
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.level_changed.connect(_on_level_changed)
	GameManager.game_over.connect(_on_game_over)
	restart_button.pressed.connect(GameManager.restart)
	menu_button.pressed.connect(GameManager.go_to_menu)
	pause_button.pressed.connect(_on_pause_pressed)
	resume_button.pressed.connect(_set_paused.bind(false))
	quit_button.pressed.connect(GameManager.quit_run)
	_on_score_changed(GameManager.score)
	_on_level_changed(GameManager.level)


func _notification(what: int) -> void:
	if is_node_ready() and what in [NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_WM_WINDOW_FOCUS_OUT]:
		_set_paused(true)


func _process(_delta: float) -> void:
	time_label.text = "Time: %.1f" % GameManager.elapsed


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score
	_pop(score_label)


func _on_level_changed(new_level: int) -> void:
	level_label.text = "Level %d" % new_level
	_pop(level_label)


func _on_game_over() -> void:
	final_score_label.text = _summary()
	pause_button.hide()
	dim.show()
	game_over_panel.show()
	_fade_in(game_over_panel)
	restart_button.grab_focus()


func _on_pause_pressed() -> void:
	_set_paused(not get_tree().paused)


func _set_paused(paused: bool) -> void:
	if GameManager.is_game_over:
		return
	get_tree().paused = paused
	dim.visible = paused
	pause_panel.visible = paused
	pause_button.texture_normal = PLAY_ICON if paused else PAUSE_ICON
	if paused:
		pause_stats_label.text = _summary()
		_fade_in(pause_panel)
		resume_button.grab_focus()


func _summary() -> String:
	return "Score: %d\nTime: %.1f s\nBest: %d\nBest Level: %d\nBest Time: %.1f s" % [GameManager.score, GameManager.elapsed, maxi(GameManager.best_score, GameManager.score), maxi(GameManager.best_level, GameManager.level), maxf(GameManager.best_time, GameManager.elapsed)]


func _fade_in(panel: Control) -> void:
	panel.modulate.a = 0.0
	panel.create_tween().tween_property(panel, "modulate:a", 1.0, 0.3)


func _pop(label: Label) -> void:
	label.pivot_offset = label.size / 2.0
	label.scale = Vector2.ONE * 1.2
	label.create_tween().tween_property(label, "scale", Vector2.ONE, 0.2)
