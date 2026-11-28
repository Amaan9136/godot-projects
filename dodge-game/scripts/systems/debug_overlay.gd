extends CanvasLayer

var label: Label = Label.new()
var elapsed: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	label.add_theme_font_size_override("font_size", 22)
	label.modulate = Color(1, 1, 1, 0.6)
	label.text = "FPS: 0"
	add_child(label)
	label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT, Control.PRESET_MODE_MINSIZE, 12)
	label.grow_vertical = Control.GROW_DIRECTION_BEGIN
	Settings.changed.connect(_refresh)
	_refresh()


func _refresh() -> void:
	visible = Settings.values.show_fps
	set_process(visible)


func _process(delta: float) -> void:
	elapsed += delta
	if elapsed < 0.25:
		return
	elapsed = 0.0
	label.text = "FPS: %d" % int(Engine.get_frames_per_second())