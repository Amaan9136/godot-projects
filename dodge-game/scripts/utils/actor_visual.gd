extends Node2D

const Art = preload("res://scripts/utils/art.gd")

@export var is_enemy: bool = false

var variant: int = randi() % 1000
var time: float = 0.0


func _process(delta: float) -> void:
	time += delta
	queue_redraw()


func _draw() -> void:
	if is_enemy:
		Art.enemy(self, Themes.current().id, Vector2.ZERO, variant, time)
	else:
		Art.player(self, Themes.current().id, Vector2.ZERO, time)
