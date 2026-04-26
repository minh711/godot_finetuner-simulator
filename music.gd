extends Node

var player: AudioStreamPlayer

func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)

	player.stream = load("res://assets/bgm.mp3")
	player.volume_db = -10
	player.autoplay = true
	player.play()

	# optional: loop handling
	player.finished.connect(func():
		player.play()
	)
