extends Control

signal selected(id: String)
signal moved

const Stage = preload("res://scripts/utils/stage.gd")
const PER_PAGE: int = 2
const GAP: float = 16.0
const ZOOM: float = 0.8
const SWIPE: float = 60.0
const TAP: float = 12.0

var strip: Control = Control.new()
var frames: Array[Panel] = []
var stages: Array[Node2D] = []
var page: int = 0
var pages: int = ceili(Themes.LIST.size() / float(PER_PAGE))
var dragging: bool = false
var press_x: float = 0.0
var tween: Tween

@onready var card_size: Vector2 = Vector2((custom_minimum_size.x - GAP) / PER_PAGE, custom_minimum_size.y)
@onready var stride: float = custom_minimum_size.x + GAP


func _ready() -> void:
	clip_contents = true
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(strip)
	for index in Themes.LIST.size():
		_add_card(index)
	page = _page_of(Themes.LIST.find(Themes.current()))
	strip.position.x = -page * stride
	highlight()
	_activate()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			press_x = event.position.x
		elif dragging:
			dragging = false
			var distance: float = event.position.x - press_x
			if absf(distance) < TAP:
				var index: int = page * PER_PAGE + int(event.position.x / (card_size.x + GAP))
				if index < Themes.LIST.size():
					selected.emit(Themes.LIST[index].id)
			go(-int(signf(distance)) if absf(distance) > SWIPE else 0)
	elif event is InputEventMouseMotion and dragging:
		if tween:
			tween.kill()
		strip.position.x = -page * stride + event.position.x - press_x


func go(step: int) -> void:
	page = clampi(page + step, 0, pages - 1)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(strip, "position:x", -page * stride, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_activate()
	moved.emit()


func highlight() -> void:
	for index in frames.size():
		var active: bool = Themes.LIST[index].id == Themes.current().id
		var style := StyleBoxFlat.new()
		style.draw_center = false
		style.border_color = Themes.LIST[index].accent if active else Color(1, 1, 1, 0.2)
		style.set_border_width_all(6 if active else 2)
		frames[index].add_theme_stylebox_override("panel", style)


func _page_of(index: int) -> int:
	return floori(index / float(PER_PAGE))


func _activate() -> void:
	for index in stages.size():
		stages[index].set_process(_page_of(index) == page)


func _add_card(index: int) -> void:
	var card := Control.new()
	card.clip_contents = true
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.size = card_size
	card.position.x = _page_of(index) * stride + (index % PER_PAGE) * (card_size.x + GAP)
	strip.add_child(card)
	var stage := Stage.new()
	stage.theme_id = Themes.LIST[index].id
	stage.actors = true
	stage.area = card_size / ZOOM
	stage.scale = Vector2.ONE * ZOOM
	card.add_child(stage)
	stages.append(stage)
	var frame := Panel.new()
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.size = card_size
	card.add_child(frame)
	frames.append(frame)
	var label := Label.new()
	label.text = Themes.LIST[index].name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position.y = card_size.y - 44.0
	label.size = Vector2(card_size.x, 32.0)
	label.add_theme_font_size_override("font_size", 24)
	card.add_child(label)
