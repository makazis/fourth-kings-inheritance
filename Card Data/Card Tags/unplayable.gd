@tool
class_name UnplayableCardTag extends Card_Tag
func _init() -> void:
	adds_tag="Unplayable"
func on_end_of_turn(card:Card):
	await card.play()
