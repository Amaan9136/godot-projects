extends Node2D

const Art = preload("res://scripts/utils/art.gd")
const SPAWN_INTERVAL: float = 0.45
const DODGE_RANGE: float = 280.0
const DODGE_WIDTH: float = 75.0
const DODGE_SPEED: float = 420.0

@export var actors: bool = false

var theme_id: String = ""
var area: Vector2 = Vector2.ZERO
var time: float = 0.0
var cooldown: float = 0.0
var player_x: float = 360.0
var enemies: Array = []


func _ready() -> void:
	if actors and area != Vector2.ZERO:
		player_x = area.x / 2.0
		for step in 120:
			_simulate(1.0 / 30.0)


func _process(delta: float) -> void:
	time += delta
	if actors:
		_simulate(delta)
	queue_redraw()


func _draw() -> void:
	var look: Dictionary = Themes.current() if theme_id.is_empty() else Themes.find(theme_id)
	var bounds: Vector2 = _bounds()
	Art.background(self, look, bounds, time)
	if not actors:
		return
	for enemy in enemies:
		Art.enemy(self, look.id, enemy.pos, enemy.variant, time)
	Art.player(self, look.id, Vector2(player_x, bounds.y * 0.86), time)


func _bounds() -> Vector2:
	return get_viewport_rect().size / global_scale if area == Vector2.ZERO else area


func _simulate(delta: float) -> void:
	var bounds: Vector2 = _bounds()
	cooldown -= delta
	if cooldown <= 0.0:
		cooldown = SPAWN_INTERVAL
		enemies.append({"pos": Vector2(randf_range(30.0, bounds.x - 30.0), -50.0), "speed": randf_range(220.0, 380.0), "variant": randi() % 1000})
	for enemy in enemies:
		enemy.pos.y += enemy.speed * delta
	enemies = enemies.filter(func(enemy: Dictionary) -> bool: return enemy.pos.y < bounds.y + 50.0)
	player_x = move_toward(player_x, _safest_x(bounds), DODGE_SPEED * delta)


func _safest_x(bounds: Vector2) -> float:
	var safest: float = player_x
	var lowest: float = INF
	for x in range(30, int(bounds.x) - 29, 30):
		var cost: float = absf(x - player_x) * 0.001 + absf(x - bounds.x / 2.0) * 0.0002
		for enemy in enemies:
			var gap: float = bounds.y * 0.86 - enemy.pos.y
			if gap > -60.0 and gap < DODGE_RANGE and absf(enemy.pos.x - x) < DODGE_WIDTH:
				cost += 2.0 - gap / DODGE_RANGE
		if cost < lowest:
			lowest = cost
			safest = x
	return safest
