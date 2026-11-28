extends Node

const PANEL: Color = Color(0.03, 0.03, 0.09, 0.75)
const LIST: Array[Dictionary] = [
	{"id": "classic", "name": "Classic", "top": Color("#1b1446"), "bottom": Color("#07071a"), "accent": Color("#3d8bff"), "glow": Color("#ff3b5c")},
	{"id": "cosmic", "name": "Cosmic", "top": Color("#050314"), "bottom": Color("#1a0b3b"), "accent": Color("#8b6cff"), "glow": Color("#22d3ee")},
	{"id": "highway", "name": "Highway", "top": Color("#252a36"), "bottom": Color("#12141c"), "accent": Color("#f5b800"), "glow": Color("#ef4444")},
	{"id": "farm", "name": "Farm", "top": Color("#2c2a63"), "bottom": Color("#c8643c"), "accent": Color("#f59e0b"), "glow": Color("#65a30d")},
	{"id": "ocean", "name": "Ocean", "top": Color("#0b6a8f"), "bottom": Color("#03142e"), "accent": Color("#22d3ee"), "glow": Color("#f472b6")},
	{"id": "synthwave", "name": "Synthwave", "top": Color("#12042b"), "bottom": Color("#4a0d5c"), "accent": Color("#ff2bd6"), "glow": Color("#00e5ff")},
	{"id": "winter", "name": "Winter", "top": Color("#0c1b3a"), "bottom": Color("#3d6391"), "accent": Color("#7dd3fc"), "glow": Color("#a78bfa")},
	{"id": "volcano", "name": "Volcano", "top": Color("#16060a"), "bottom": Color("#5c1408"), "accent": Color("#ff6a1a"), "glow": Color("#facc15")},
]

var applied: String = ""


func _ready() -> void:
	Settings.changed.connect(_apply_style)
	_apply_style()


func find(id: String) -> Dictionary:
	for look in LIST:
		if look.id == id:
			return look
	return LIST[0]


func current() -> Dictionary:
	return find(str(Settings.values.theme))


func _apply_style() -> void:
	var look: Dictionary = current()
	if look.id == applied:
		return
	applied = look.id
	var sheet: Theme = ThemeDB.get_default_theme()
	var accent: Color = look.accent
	for type in ["Button", "LineEdit"]:
		sheet.set_stylebox("normal", type, _box(PANEL, Color(accent, 0.8)))
		sheet.set_stylebox("focus", type, _box(Color.TRANSPARENT, Color(1, 1, 1, 0.7)))
	sheet.set_stylebox("hover", "Button", _box(Color(accent, 0.35), accent))
	sheet.set_stylebox("pressed", "Button", _box(Color(accent, 0.6), Color.WHITE))
	sheet.set_stylebox("disabled", "Button", _box(PANEL, Color(1, 1, 1, 0.2)))
	sheet.set_stylebox("slider", "HSlider", _bar(PANEL))
	sheet.set_stylebox("grabber_area", "HSlider", _bar(accent))
	sheet.set_stylebox("grabber_area_highlight", "HSlider", _bar(accent.lightened(0.3)))
	sheet.set_color("font_shadow_color", "Label", Color(0, 0, 0, 0.6))
	sheet.set_constant("shadow_offset_x", "Label", 2)
	sheet.set_constant("shadow_offset_y", "Label", 2)
	sheet.set_type_variation("ScreenTitle", "Label")
	sheet.set_color("font_outline_color", "ScreenTitle", accent)
	sheet.set_color("font_shadow_color", "ScreenTitle", Color(look.glow, 0.8))
	sheet.set_constant("outline_size", "ScreenTitle", 8)
	sheet.set_constant("shadow_offset_x", "ScreenTitle", 4)
	sheet.set_constant("shadow_offset_y", "ScreenTitle", 6)


func _box(fill: Color, border: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(2)
	box.set_corner_radius_all(10)
	box.set_content_margin_all(10)
	return box


func _bar(fill: Color) -> StyleBoxFlat:
	var bar := StyleBoxFlat.new()
	bar.bg_color = fill
	bar.set_corner_radius_all(4)
	bar.set_content_margin_all(4)
	return bar
