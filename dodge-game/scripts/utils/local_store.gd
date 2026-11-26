extends Node

const PATH: String = "user://save.cfg"

var config: ConfigFile = ConfigFile.new()


func _ready() -> void:
	config.load(PATH)


func read(section: String, key: String, default: Variant) -> Variant:
	return config.get_value(section, key, default)


func write(section: String, values: Dictionary) -> void:
	for key in values:
		config.set_value(section, key, values[key])
	config.save(PATH)
