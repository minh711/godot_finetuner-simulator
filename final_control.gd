extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_sound("end.mp3")
	$Background.texture = load("res://assets/" + Global.selected_background + ".png")
	
	match Global.selected_background:
		"ed_1":
			$Message.text = "#1 Broken Ending: Can It Still Able To Be Fixed?"
		"ed_2":
			$Message.text = "#2 Perfection Ending: Replaced Human-Or Is It?"
		"ed_3":
			$Message.text = "#3 Corruption Ending: Everyone Loves Me"
		"ed_4":
			$Message.text = "#4 Happiness Ending: Connect Everyone Together"
		"ed_5":
			$Message.text = "#5 Poor Ending: Run Out Of Budget"
		"ed_6":
			$Message.text = "#6 Destruction Ending: The City Electricity Was Gone"
		"ed_7":
			$Message.text = "#7 World's End Ending: Nobody Can Fix Me"


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
