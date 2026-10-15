extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 1.0
@export var min_fall_speed: float = 200.0
@export var max_fall_speed: float = 350.0

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	_spawn_enemy()

func _spawn_enemy() -> void:
	var enemy := enemy_scene.instantiate()
	var screen_width: float = get_viewport_rect().size.x
	var margin: float = 30.0
	enemy.position = Vector2(randf_range(margin, screen_width - margin), -50.0)
	enemy.fall_speed = randf_range(min_fall_speed, max_fall_speed)
	get_parent().add_child(enemy)
