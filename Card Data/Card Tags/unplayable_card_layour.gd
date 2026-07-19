extends "res://addons/simple_cards/card/card_layout/default_card_layout.gd"

func _update_display() -> void:
	var data = card_resource as Gu_Move
	if data:
		name_label.text = data.card_name
		description_label.text = data.card_description
		
	display_updated.emit()
