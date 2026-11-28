extends Control

const MUSIC_ICON: Texture2D = preload("res://assets/icons/music.svg")
const SPEAKER_ICON: Texture2D = preload("res://assets/icons/volume-2.svg")
const MUTED_ICON: Texture2D = preload("res://assets/icons/volume-x.svg")

@onready var music_button: TextureButton = $VBoxContainer/MusicRow/MusicButton
@onready var music_slider: HSlider = $VBoxContainer/MusicRow/MusicSlider
@onready var sfx_button: TextureButton = $VBoxContainer/SfxRow/SfxButton
@onready var sfx_slider: HSlider = $VBoxContainer/SfxRow/SfxSlider
@onready var carousel: Control = $VBoxContainer/ThemeCarousel
@onready var prev_button: Button = $VBoxContainer/ThemeNav/PrevButton
@onready var page_label: Label = $VBoxContainer/ThemeNav/PageLabel
@onready var next_button: Button = $VBoxContainer/ThemeNav/NextButton
@onready var fps_button: Button = $VBoxContainer/FpsButton
@onready var back_button: Button = $VBoxContainer/BackButton


func _ready() -> void:
	_refresh()
	music_slider.value_changed.connect(func(value: float) -> void: _update("music", value))
	sfx_slider.value_changed.connect(func(value: float) -> void: _update("sfx", value))
	sfx_slider.drag_ended.connect(func(_changed: bool) -> void: AudioManager.score_player.play())
	music_button.pressed.connect(func() -> void: _update("music_muted", not Settings.values.music_muted))
	sfx_button.pressed.connect(func() -> void: _update("sfx_muted", not Settings.values.sfx_muted))
	fps_button.pressed.connect(func() -> void: _update("show_fps", not Settings.values.show_fps))
	carousel.selected.connect(func(id: String) -> void: _update("theme", id))
	carousel.moved.connect(_refresh)
	prev_button.pressed.connect(carousel.go.bind(-1))
	next_button.pressed.connect(carousel.go.bind(1))
	back_button.pressed.connect(GameManager.go_to_menu)
	tree_exiting.connect(Settings.save)


func _update(key: String, value: Variant) -> void:
	Settings.set_value(key, value)
	_refresh()


func _refresh() -> void:
	music_slider.set_value_no_signal(Settings.values.music)
	sfx_slider.set_value_no_signal(Settings.values.sfx)
	music_slider.modulate.a = 0.4 if Settings.values.music_muted else 1.0
	sfx_slider.modulate.a = 0.4 if Settings.values.sfx_muted else 1.0
	music_button.texture_normal = MUTED_ICON if Settings.values.music_muted else MUSIC_ICON
	sfx_button.texture_normal = MUTED_ICON if Settings.values.sfx_muted else SPEAKER_ICON
	fps_button.text = "Show FPS: %s" % ("On" if Settings.values.show_fps else "Off")
	carousel.highlight()
	prev_button.disabled = carousel.page == 0
	next_button.disabled = carousel.page == carousel.pages - 1
	page_label.text = "%d / %d" % [carousel.page + 1, carousel.pages]