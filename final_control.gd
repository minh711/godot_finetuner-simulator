extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_sound("end.mp3")
	$Background.texture = load("res://assets/" + Global.selected_background + ".png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func play_sound(sound_name: String) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = load("res://assets/%s" % sound_name)
	add_child(player)
	player.play()

	# auto-cleanup after sound finishes
	player.finished.connect(func(): player.queue_free())
