class_name Spec
extends Resource   # use Resource so it’s reusable and storable

var value: int = 0
var name: String = ""
var code: String = ""
var description: String = ""
var stress: int = 0
var effects: Dictionary = {}   # map<string, number>

# Format value like 001, 011, etc.
func display_value() -> String:
	return str(value).pad_zeros(3)

func boost(delta: int):
	value += delta
	
func change_by_percent(percent: int):
	value += value * percent / 100


# Apply an effect by name
# Returns true if the effect does NOT exist
# Returns false if it exists (and applies it)
func apply_effect(effect_name: String) -> bool:
	if not effects.has(effect_name):
		return true
	
	# effect exists → apply it
	value += effects[effect_name]
	return false


# Decrease all effects over time
func update_effects():
	var to_remove = []

	for key in effects.keys():
		effects[key] -= 1
		
		if effects[key] <= 0:
			to_remove.append(key)

	# remove after iteration (safe)
	for key in to_remove:
		effects.erase(key)
		

const HIGH_STRESS := 7
const MID_STRESS := 5
const LOW_STRESS := 3

func update_value(delta: int):
	if stress >= HIGH_STRESS:
		value -= max(delta * 2, 2)
		return

	if stress >= MID_STRESS:
		value -= delta
		return

	if stress >= LOW_STRESS:
		value += delta / 2
		return

	value += delta
