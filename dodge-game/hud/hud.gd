extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel
@onready var level_label: Label = $LevelLabel
@onready var dim: ColorRect = $Dim
@onready var game_over_panel: VBoxContainer = $GameOverPanel
@onready var final_score_label: Label = $GameOverPanel/FinalScoreLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton
@onready var menu_button: Button = $GameOverPanel/MenuButton


func _ready() -> void:
	dim.hide()
	game_over_panel.hide()
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.level_changed.connect(_on_level_changed)
	GameManager.game_over.connect(_on_game_over)
	restart_button.pressed.connect(GameManager.restart)
	menu_button.pressed.connect(GameManager.go_to_menu)
	_on_score_changed(GameManager.score)
	_on_level_changed(GameManager.level)


func _process(_delta: float) -> void:
	time_label.text = "Time: %.1f" % GameManager.elapsed


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score


func _on_level_changed(new_level: int) -> void:
	level_label.text = "Level %d" % new_level


func _on_game_over() -> void:
	final_score_label.text = "Score: %d\nTime: %.1f s" % [GameManager.score, GameManager.elapsed]
	dim.show()
	game_over_panel.show()
	restart_button.grab_focus()
