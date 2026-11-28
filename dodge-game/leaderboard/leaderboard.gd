extends Control

const PAGE_SIZE: int = 50
const MEDALS: Dictionary = {1: Color(1.0, 0.82, 0.29), 2: Color(0.84, 0.86, 0.88), 3: Color(0.88, 0.58, 0.35)}

@onready var status_label: Label = $VBoxContainer/StatusLabel
@onready var scroll: ScrollContainer = $VBoxContainer/ScrollContainer
@onready var rows: VBoxContainer = $VBoxContainer/ScrollContainer/Rows
@onready var back_button: Button = $VBoxContainer/BackButton

var loading: bool = false
var done: bool = false


func _ready() -> void:
	back_button.pressed.connect(GameManager.go_to_menu)
	scroll.get_v_scroll_bar().value_changed.connect(_on_scroll)
	_load_page()


func _on_scroll(value: float) -> void:
	if value + scroll.get_v_scroll_bar().page >= scroll.get_v_scroll_bar().max_value - 300.0:
		_load_page()


func _load_page() -> void:
	if loading or done:
		return
	loading = true
	var data := await Api.request(HTTPClient.METHOD_GET, "/leaderboard?skip=%d&limit=%d" % [rows.get_child_count(), PAGE_SIZE])
	loading = false
	if data.has("error"):
		status_label.text = "Connect to the internet to view the leaderboard" if rows.get_child_count() == 0 else ""
		return
	for entry in data.entries:
		_add_row(rows.get_child_count() + 1, entry)
	done = data.entries.size() < PAGE_SIZE
	status_label.text = "" if rows.get_child_count() > 0 else "No players yet"


func _add_row(rank: int, entry: Dictionary) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.3, 0.6, 1.0, 0.35) if entry.me else Color(1, 1, 1, 0.07)
	style.set_corner_radius_all(16)
	style.set_content_margin_all(16)
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.add_theme_stylebox_override("panel", style)
	var row := HBoxContainer.new()
	row.add_child(_cell("%d" % rank, 80.0, MEDALS.get(rank, Color.WHITE), HORIZONTAL_ALIGNMENT_LEFT))
	row.add_child(_cell(entry.name, 0.0, Color.WHITE, HORIZONTAL_ALIGNMENT_LEFT))
	row.add_child(_cell("%.1f s" % entry.bestTime, 150.0, Color.WHITE, HORIZONTAL_ALIGNMENT_RIGHT))
	row.add_child(_cell("%d" % entry.bestScore, 120.0, Color.WHITE, HORIZONTAL_ALIGNMENT_RIGHT))
	panel.add_child(row)
	rows.add_child(panel)


func _cell(text: String, width: float, color: Color, align: HorizontalAlignment) -> Label:
	var label := Label.new()
	label.text = text
	label.custom_minimum_size.x = width
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL if width == 0.0 else Control.SIZE_FILL
	label.horizontal_alignment = align
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.add_theme_font_size_override("font_size", 30)
	label.add_theme_color_override("font_color", color)
	return label