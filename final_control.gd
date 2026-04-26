extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background.texture = load(Global.selected_background)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
