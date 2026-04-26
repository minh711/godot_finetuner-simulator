extends Control

var specs = {}
var last_hand_value := 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# --- Create Specs ---
	var hand_spec = Spec.new()
	hand_spec.value = 20
	hand_spec.name = "Connectivity"
	hand_spec.code = "CNT"
	hand_spec.description = "The ability of the model to connect to a thing."

	var core_spec = Spec.new()
	core_spec.value = 20
	core_spec.name = "Core"
	core_spec.code = "COR"
	core_spec.description = "Central processing unit."

	var interface_spec = Spec.new()
	interface_spec.value = 20
	interface_spec.name = "Interface"
	interface_spec.code = "INT"
	interface_spec.description = "Interaction layer."

	var processor_spec = Spec.new()
	processor_spec.value = 20
	processor_spec.name = "Processor"
	processor_spec.code = "CPU"
	processor_spec.description = "Handles computation."

	var leg_spec = Spec.new()
	leg_spec.value = 20
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
		
	$UnlockedEndings.text = "Unlocked\nEndings " + str(Global.unlocked_endings) + "/7"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update():
	update_all_effects()
	check()


func _on_btn_hand_pressed() -> void:
	onClick("CNT")


func _on_btn_core_pressed() -> void:
	onClick("COR")


func _on_btn_interface_pressed() -> void:
	onClick("INT")


func _on_btn_processor_pressed() -> void:
	onClick("CPU")
	

func _on_btn_leg_pressed() -> void:
	onClick("LEG")


func apply_spec_to_button(button: Button) -> void:
	var spec = specs.get(button)
	if spec == null:
		return

	# Display formatted value (001, 011, etc.)
	button.text = spec.display_value()

	# Tooltip from spec
	button.tooltip_text = "==%s==\nValue: %s\nStress: %s" % [
		spec.name.to_upper(),
		#spec.description,
		spec.display_value(),
		spec.stress
	]

	# --- COLOR LOGIC ---
	if spec.value >= 30:
		var green = Color(0, 1, 0)
		button.add_theme_color_override("font_color", green)
		button.add_theme_color_override("font_hover_color", green)
		button.add_theme_color_override("font_pressed_color", green)

	elif spec.value <= 10:
		var red = Color(1, 0, 0)
		button.add_theme_color_override("font_color", red)
		button.add_theme_color_override("font_hover_color", red)
		button.add_theme_color_override("font_pressed_color", red)

	else:
		var white = Color(1, 1, 1)
		button.add_theme_color_override("font_color", white)
		button.add_theme_color_override("font_hover_color", white)
		button.add_theme_color_override("font_pressed_color", white)


func update_all_effects() -> void:
	for spec in specs.values():
		spec.update_effects()


func any_spec(condition: Callable) -> bool:
	for spec in specs.values():
		if condition.call(spec):
			return true
	return false
	

func all_specs(condition: Callable) -> bool:
	for spec in specs.values():
		if not condition.call(spec):
			return false
	return true

func check() -> void:
	#Global.unlocked_endings += 1
	
	var sum = 0
	
	var hand = specs[$BtnHand]
	var core = specs[$BtnCore]
	var interface = specs[$BtnInterface]
	var processor = specs[$BtnProcessor]
	var leg = specs[$BtnLeg]
	
	for spec in specs.values():
		sum += spec.value
		$Score.text = "Score: %d" % sum
	
	if last_hand_value < 30 and hand.value >= 30:
		$Hand.texture = load("res://assets/hand_3.png")
		play_sound("upgrade.mp3")

	if last_hand_value >10 and hand.value <= 10:
		$Hand.texture = load("res://assets/hand_1.png")
		play_sound("downgrade.mp3")
	
	last_hand_value = hand.value
	
	# ENDINGS
	#if sum >= 100 and hand.value > 20:
		#Global.selected_background = "ed_2"
		#get_tree().change_scene_to_file("res://final.tscn")
		
	#if all_specs(func(s): return s.value > 10):
		#print("All specs are strong")
		#return

func play_sound(sound_name: String) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = load("res://assets/%s" % sound_name)
	add_child(player)
	player.play()

	# auto-cleanup after sound finishes
	player.finished.connect(func(): player.queue_free())
	
	
func onClick(code: String) -> void:
	play_sound("click.mp3")
	
	for button in specs.keys():
		var spec = specs[button]
		
		if spec.code == code:
			spec.stress += 1
			spec.update_value(1)
		else:
			spec.stress = max(0, spec.stress - 1)
			
		apply_spec_to_button(button)
	
	update()


func _on_btn_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
