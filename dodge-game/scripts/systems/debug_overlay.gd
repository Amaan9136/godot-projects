extends CanvasLayer

var label: Label = Label.new()
var elapsed: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	if not OS.is_debug_build():
		hide()
		set_process(false)
		return
	label.add_theme_font_size_override("font_size", 22)
	label.modulate = Color(1, 1, 1, 0.6)
	label.text = "FPS: 0"
	add_child(label)
	label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT, Control.PRESET_MODE_MINSIZE, 12)
	label.grow_vertical = Control.GROW_DIRECTION_BEGIN


func _process(delta: float) -> void:
	elapsed += delta
	if elapsed < 0.25:
		return
	elapsed = 0.0
	label.text = "FPS: %d\nFrame: %.1f ms\nDraw calls: %d\nNodes: %d\nMem: %.1f MB" % [
		int(Engine.get_frames_per_second()),
		delta * 1000.0,
		int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),
		int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
		Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0
	]