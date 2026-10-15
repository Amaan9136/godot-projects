extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if GameManager.is_game_over and event.is_action_pressed("restart"):
		GameManager.restart()