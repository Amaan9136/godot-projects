extends Node

const SCORE_SOUND: AudioStream = preload("res://assets/audio/score.wav")
const LEVEL_SOUND: AudioStream = preload("res://assets/audio/level_up.wav")
const HIT_SOUND: AudioStream = preload("res://assets/audio/hit.wav")
const MUSIC: AudioStream = preload("res://assets/audio/music.wav")

var score_player: AudioStreamPlayer
var level_player: AudioStreamPlayer
var hit_player: AudioStreamPlayer
var music_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for bus in ["music", "sfx"]:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count - 1, bus)
	score_player = _make_player(SCORE_SOUND, -12.0, "sfx")
	level_player = _make_player(LEVEL_SOUND, -8.0, "sfx")
	hit_player = _make_player(HIT_SOUND, -4.0, "sfx")
	music_player = _make_player(MUSIC, -18.0, "music")
	music_player.finished.connect(music_player.play)
	music_player.play()
	GameManager.score_changed.connect(func(_score: int) -> void: score_player.play())
	GameManager.level_changed.connect(func(_level: int) -> void: level_player.play())
	GameManager.game_over.connect(hit_player.play)
	Settings.changed.connect(_apply)
	_apply()


func _apply() -> void:
	for bus in ["music", "sfx"]:
		var index: int = AudioServer.get_bus_index(bus)
		AudioServer.set_bus_volume_db(index, linear_to_db(maxf(Settings.values[bus], 0.001)))
		AudioServer.set_bus_mute(index, Settings.values[bus + "_muted"] or Settings.values[bus] <= 0.0)


func _make_player(stream: AudioStream, volume: float, bus: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume
	player.bus = bus
	add_child(player)
	return player