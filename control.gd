extends Control

var specs = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$BtnHand.tooltip_text = """
		#==CONNECTIVITY==
		#The ability of the model to connect to a thing.
	#"""
	
	# --- Create Specs ---
	var hand_spec = Spec.new()
	hand_spec.value = 1
	hand_spec.name = "Connectivity"
	hand_spec.code = "CNT"
	hand_spec.description = "The ability of the model to connect to a thing."

	var core_spec = Spec.new()
	core_spec.value = 11
	core_spec.name = "Core"
	core_spec.code = "COR"
	core_spec.description = "Central processing unit."

	var interface_spec = Spec.new()
	interface_spec.value = 5
	interface_spec.name = "Interface"
	interface_spec.code = "INT"
	interface_spec.description = "Interaction layer."

	var processor_spec = Spec.new()
	processor_spec.value = 23
	processor_spec.name = "Processor"
	processor_spec.code = "CPU"
	processor_spec.description = "Handles computation."

	var leg_spec = Spec.new()
	leg_spec.value = 7
	leg_spec.name = "Mobility"
	leg_spec.code = "LEG"
	leg_spec.description = "Movement capability."

	# --- Map buttons to specs ---
	specs[$BtnHand] = hand_spec
	specs[$BtnCore] = core_spec
	specs[$BtnInterface] = interface_spec
	specs[$BtnProcessor] = processor_spec
	specs[$BtnLeg] = leg_spec

	# --- Apply spec to each button immediately ---
	for button in specs.keys():
		apply_spec_to_button(button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_1_pressed():
	#get_tree().change_scene_to_file("res://final.tscn")
	pass


func _on_btn_hand_pressed() -> void:
	$BtnHand.text = "001"
	$BtnHand.add_theme_color_override("font_color", Color(1, 0, 0))
	$BtnHand.add_theme_color_override("font_hover_color", Color(1, 0, 0))
	$BtnHand.add_theme_color_override("font_pressed_color", Color(1, 0, 0))
	#Global.selected_background = "res://assets/ed_2.png"
	#get_tree().change_scene_to_file("res://final.tscn")


func _on_btn_core_pressed() -> void:
	get_tree().change_scene_to_file("res://final.tscn")


func _on_btn_interface_pressed() -> void:
	get_tree().change_scene_to_file("res://final.tscn")


func _on_btn_processor_pressed() -> void:
	get_tree().change_scene_to_file("res://final.tscn")


func _on_btn_leg_pressed() -> void:
	get_tree().change_scene_to_file("res://final.tscn")


func apply_spec_to_button(button: Button) -> void:
	var spec = specs.get(button)
	if spec == null:
		return

	# Display formatted value (001, 011, etc.)
	button.text = spec.display_value()

	# Tooltip from spec
	button.tooltip_text = "==%s==\n%s" % [spec.name.to_upper(), spec.description]

	# Optional styling
	button.add_theme_color_override("font_color", Color(1, 1, 1))
	button.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	button.add_theme_color_override("font_pressed_color", Color(1, 1, 1))
