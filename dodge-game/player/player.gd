extends CharacterBody2D

const HALF_WIDTH: float = 24.0

@export var speed: float = 400.0
@export var touch_speed: float = 900.0
@export var bottom_margin: float = 180.0

var touching: bool = false
var touch_index: int = -1
var touch_x: float = 0.0


func _ready() -> void:
	position.y = get_viewport_rect().size.y - bottom_margin


func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		touching = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touching = true
			touch_index = event.index
			touch_x = event.position.x
		elif event.index == touch_index:
			touching = false
	elif event is InputEventScreenDrag and event.index == touch_index:
		touch_x = event.position.x


func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = direction * speed
	elif touching:
		velocity.x = clampf((touch_x - position.x) * 15.0, -touch_speed, touch_speed)
	else:
		velocity.x = 0.0
	move_and_slide()
	_clamp_to_screen()


func _clamp_to_screen() -> void:
	var screen_width: float = get_viewport_rect().size.x
	position.x = clampf(position.x, HALF_WIDTH, screen_width - HALF_WIDTH)