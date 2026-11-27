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


func _ready() -> void:
	dim.hide()
	game_over_panel.hide()
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.level_changed.connect(_on_level_changed)
	GameManager.game_over.connect(_on_game_over)
	restart_button.pressed.connect(GameManager.restart)
	menu_button.pressed.connect(GameManager.go_to_menu)
	pause_button.pressed.connect(_on_pause_pressed)
	_on_score_changed(GameManager.score)
	_on_level_changed(GameManager.level)


func _process(_delta: float) -> void:
	time_label.text = "Time: %.1f" % GameManager.elapsed


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score


func _on_level_changed(new_level: int) -> void:
	level_label.text = "Level %d" % new_level


func _on_game_over() -> void:
	final_score_label.text = "Score: %d\nTime: %.1f s\nBest: %d\nBest Level: %d\nBest Time: %.1f s" % [GameManager.score, GameManager.elapsed, GameManager.best_score, GameManager.best_level, GameManager.best_time]
	pause_button.hide()
	dim.show()
	game_over_panel.show()
	restart_button.grab_focus()



func _on_pause_pressed() -> void:
	var paused: bool = not get_tree().paused
	get_tree().paused = paused
	dim.visible = paused
	pause_button.texture_normal = PLAY_ICON if paused else PAUSE_ICON
