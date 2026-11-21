extends Node

signal game_over
signal score_changed(new_score: int)
signal level_changed(new_level: int)

const LEVEL_DURATION: float = 10.0
const MENU_SCENE: String = "res://menu/menu.tscn"
const GAME_SCENE: String = "res://main.tscn"

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


func reset_state() -> void:
	is_game_over = false
	score = 0
	elapsed = 0.0
	level = 1
	get_tree().paused = false


func restart() -> void:
	reset_state()
	get_tree().reload_current_scene()


func start_game() -> void:
	reset_state()
	get_tree().change_scene_to_file(GAME_SCENE)


func go_to_menu() -> void:
	reset_state()
	get_tree().change_scene_to_file(MENU_SCENE)
