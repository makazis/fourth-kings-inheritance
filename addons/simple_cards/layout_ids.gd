# AUTO-GENERATED FILE - DO NOT EDIT MANUALLY
# This file is regenerated when layouts are modified in the Card Layouts panel

class_name LayoutID

const MOVE: StringName = &"Move"
const DEFAULT: StringName = &"default"
const DEFAULT_BACK: StringName = &"default_back"
const UNPLAYABLE: StringName = &"unplayable"


## Returns all available layout IDs
static func get_all() -> Array[StringName]:
	return [
		MOVE,
		DEFAULT,
		DEFAULT_BACK,
		UNPLAYABLE
	]


## Check if a layout ID is valid
static func is_valid(id: StringName) -> bool:
	return id in get_all()