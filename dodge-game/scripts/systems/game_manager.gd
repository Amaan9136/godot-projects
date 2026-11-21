extends Node

signal game_over
signal score_changed(new_score: int)
signal level_changed(new_level: int)

const LEVEL_DURATION: float = 10.0  # seconds per difficulty level

var is_game_over: bool = false
var score: int = 0
var elapsed: float = 0.0
var level: int = 1


func _process(delta: float) -> void:
	if is_game_over:
		return
	elapsed += delta

	var new_level: int = 1 + int(elapsed / LEVEL_DURATION)
	if new_level != level:
		level = new_level
		print("Level ", level)  # temporary debug output
		level_changed.emit(level)


func add_score(amount: int = 1) -> void:
	if is_game_over:
		return
	score += amount
	score_changed.emit(score)


func trigger_game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	get_tree().paused = true
	game_over.emit()


func restart() -> void:
	# An autoload is NOT recreated when the scene reloads, so we must reset by hand.
	is_game_over = false
	score = 0
	elapsed = 0.0
	level = 1
	get_tree().paused = false
	get_tree().reload_current_scene()