extends Control

var specs = {}
var last_values := {}
var UPGRADE_VALUE = 15
var DEFAULT_VALUE = 10
var DOWNGRADE_VALUE = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# --- Create Specs ---
	var hand_spec = Spec.new()
	hand_spec.value = DEFAULT_VALUE
	hand_spec.name = "Connectivity"
	hand_spec.code = "CNT"
	hand_spec.description = "The ability of the model to connect to a thing."

	var core_spec = Spec.new()
	core_spec.value = DEFAULT_VALUE
	core_spec.name = "Core"
	core_spec.code = "COR"
	core_spec.description = "Central processing unit."

	var interface_spec = Spec.new()
	interface_spec.value = DEFAULT_VALUE
	interface_spec.name = "Interface"
	interface_spec.code = "INT"
	interface_spec.description = "Interaction layer."

	var processor_spec = Spec.new()
	processor_spec.value = DEFAULT_VALUE
	processor_spec.name = "Processor"
	processor_spec.code = "CPU"
	processor_spec.description = "Handles computation."

	var leg_spec = Spec.new()
	leg_spec.value = DEFAULT_VALUE
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
		var spec = specs[button]
		last_values[spec.code] = spec.value
		apply_spec_to_button(button)
		
	$UnlockedEndings.text = "Unlocked\nEndings " + str(Global.unlocked_endings.size()) + "/7"


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
	if spec.value >= UPGRADE_VALUE:
		var green = Color(0, 1, 0)
		button.add_theme_color_override("font_color", green)
		button.add_theme_color_override("font_hover_color", green)
		button.add_theme_color_override("font_pressed_color", green)

	elif spec.value <= DOWNGRADE_VALUE:
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
	
	for button in specs.keys():
		var spec = specs[button]
		var last = last_values[spec.code]

		if last < UPGRADE_VALUE and spec.value >= UPGRADE_VALUE:
			play_sound("upgrade.mp3")

			if spec.code == "CNT":
				$Hand.texture = load("res://assets/hand_3.png")
			elif spec.code == "COR":
				$Core.texture = load("res://assets/core_3.png")
			elif spec.code == "INT":
				$Head.texture = load("res://assets/head_3.png")
			elif spec.code == "CPU":
				pass
			elif spec.code == "LEG":
				$Leg.texture = load("res://assets/leg_3.png")

		if last > DOWNGRADE_VALUE and spec.value <= DOWNGRADE_VALUE:
			play_sound("downgrade.mp3")

			if spec.code == "CNT":
				$Hand.texture = load("res://assets/hand_1.png")
			elif spec.code == "COR":
				$Core.texture = load("res://assets/core_1.png")
			elif spec.code == "INT":
				$Head.texture = load("res://assets/head_1.png")
			elif spec.code == "CPU":
				pass
			elif spec.code == "LEG":
				$Leg.texture = load("res://assets/leg_1.png")

		last_values[spec.code] = spec.value
	
	# ENDINGS
	if any_spec(func(s): return s.value < 0):
		go_to_final("ed_1")
		
	if all_specs(func(s): return s.value > 15):
		go_to_final("ed_2")
	
	if (sum < 70 and leg.value > 15):
		go_to_final("ed_3")
	
	if (sum < 70 and hand.value > 15):
		go_to_final("ed_4")
	
	if (sum < 70 and interface.value > 15):
		go_to_final("ed_5")
	
	if (sum < 70 and core.value > 15):
		go_to_final("ed_6")
		
	if (sum < 70 and processor.value > 15):
		go_to_final("ed_7")


func go_to_final(ending: String):
	Global.selected_background = ending
	Global.unlocked_endings[ending] = true
	get_tree().change_scene_to_file("res://final.tscn")

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
