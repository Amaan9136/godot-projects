extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel
@onready var game_over_panel: VBoxContainer = $GameOverPanel
@onready var final_score_label: Label = $GameOverPanel/FinalScoreLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton


func _ready() -> void:
	game_over_panel.hide()
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.game_over.connect(_on_game_over)
	restart_button.pressed.connect(GameManager.restart)
	_on_score_changed(GameManager.score)


func _process(_delta: float) -> void:
	time_label.text = "Time: %.1f" % GameManager.elapsed


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score


func _on_game_over() -> void:
	final_score_label.text = "Score: %d\nTime: %.1f s" % [GameManager.score, GameManager.elapsed]
	game_over_panel.show()