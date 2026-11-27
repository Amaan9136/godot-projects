extends Node

signal game_over
signal score_changed(new_score: int)
signal level_changed(new_level: int)

const LEVEL_DURATION: float = 10.0
const AUTH_SCENE: String = "res://auth/auth.tscn"
const MENU_SCENE: String = "res://menu/menu.tscn"
const GAME_SCENE: String = "res://main.tscn"
const SAVE_SECTION: String = "guest"

var is_game_over: bool = false
var score: int = 0
var elapsed: float = 0.0
var level: int = 1
var best_score: int = 0
var best_level: int = 1


func _ready() -> void:
	load_best()


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
	best_score = maxi(best_score, score)
	best_level = maxi(best_level, level)
	if Api.user.is_empty():
		LocalStore.write(SAVE_SECTION, {"best_score": best_score, "best_level": best_level})
	else:
		Api.request(HTTPClient.METHOD_PUT, "/score", {"score": score, "level": level})
	game_over.emit()


func load_best() -> void:
	best_score = LocalStore.read(SAVE_SECTION, "best_score", 0)
	best_level = LocalStore.read(SAVE_SECTION, "best_level", 1)


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


func go_to_auth() -> void:
	reset_state()
	get_tree().change_scene_to_file(AUTH_SCENE)
