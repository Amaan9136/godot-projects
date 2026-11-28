extends Control

const MIN_MS: int = 1000

@onready var logo: TextureRect = $Logo
@onready var dots: Control = $Dots

var started: int = Time.get_ticks_msec()


func _ready() -> void:
	ResourceLoader.load_threaded_request(GameManager.MENU_SCENE)


func _process(_delta: float) -> void:
	var elapsed: int = Time.get_ticks_msec() - started
	logo.scale = Vector2.ONE * (1.0 + 0.03 * sin(elapsed / 300.0))
	for dot: ColorRect in dots.get_children():
		dot.position.y = -maxf(0.0, sin(elapsed / 150.0 - dot.get_index() * 0.8)) * 28.0
	if elapsed >= MIN_MS and ResourceLoader.load_threaded_get_status(GameManager.MENU_SCENE) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(GameManager.MENU_SCENE))