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
	score_player = _make_player(SCORE_SOUND, -12.0)
	level_player = _make_player(LEVEL_SOUND, -8.0)
	hit_player = _make_player(HIT_SOUND, -4.0)
	music_player = _make_player(MUSIC, -18.0)
	music_player.finished.connect(music_player.play)
	music_player.play()
	GameManager.score_changed.connect(func(_score: int) -> void: score_player.play())
	GameManager.level_changed.connect(func(_level: int) -> void: level_player.play())
	GameManager.game_over.connect(hit_player.play)


func _make_player(stream: AudioStream, volume: float) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume
	add_child(player)
	return player