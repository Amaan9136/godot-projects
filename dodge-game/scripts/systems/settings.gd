extends Node

signal changed

const SECTION: String = "settings"
const DEFAULTS: Dictionary = {"music": 0.8, "music_muted": false, "sfx": 0.8, "sfx_muted": false, "show_fps": false, "theme": "classic"}

var values: Dictionary = DEFAULTS.duplicate()
var dirty: bool = false


func _ready() -> void:
	load_local()


func load_local() -> void:
	var stored: Dictionary = {}
	for key in DEFAULTS:
		stored[key] = LocalStore.read(SECTION, key, DEFAULTS[key])
	apply(stored)


func apply(source: Dictionary) -> void:
	for key in DEFAULTS:
		values[key] = source.get(key, DEFAULTS[key])
	changed.emit()


func set_value(key: String, value: Variant) -> void:
	dirty = dirty or values[key] != value
	values[key] = value
	changed.emit()


func save() -> void:
	if not dirty:
		return
	dirty = false
	if Api.user.is_empty():
		LocalStore.write(SECTION, values)
	else:
		Api.request(HTTPClient.METHOD_PUT, "/settings", values)