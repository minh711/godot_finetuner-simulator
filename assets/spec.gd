class_name Spec
extends Resource   # use Resource so it’s reusable and storable

var value: int = 0
var name: String = ""
var code: String = ""
var description: String = ""
var stress: float = 0.0
var effects: Dictionary = {}   # map<string, number>

# Format value like 001, 011, etc.
func display_value() -> String:
	return str(value).pad_zeros(3)
