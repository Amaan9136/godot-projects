extends Node2D

@export var enemy_scene: PackedScene

# Level 1 values
@export var spawn_interval: float = 1.0
@export var min_fall_speed: float = 200.0
@export var max_fall_speed: float = 350.0

# How difficulty scales per level
@export var min_spawn_interval: float = 0.3  # never spawn faster than this
@export var interval_factor: float = 0.9     # each level: interval *= 0.9
@export var speed_step: float = 25.0         # each level: +25 speed

var current_min_speed: float
var current_max_speed: float

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	GameManager.level_changed.connect(_apply_difficulty)
	_apply_difficulty(GameManager.level)


func _apply_difficulty(level: int) -> void:
	var steps: int = level - 1
	spawn_timer.wait_time = maxf(min_spawn_interval, spawn_interval * pow(interval_factor, steps))
	current_min_speed = min_fall_speed + speed_step * steps
	current_max_speed = max_fall_speed + speed_step * steps


func _on_spawn_timer_timeout() -> void:
	_spawn_enemy()


func _spawn_enemy() -> void:
	var enemy := enemy_scene.instantiate()
	var screen_width: float = get_viewport_rect().size.x
	var margin: float = 30.0
	enemy.position = Vector2(randf_range(margin, screen_width - margin), -50.0)
	enemy.fall_speed = randf_range(current_min_speed, current_max_speed)
	get_parent().add_child(enemy)