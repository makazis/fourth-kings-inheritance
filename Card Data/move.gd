@tool  # Optional: enables live data preview in the editor
extends CardLayout

@onready var name_label: Label = $SubViewport/DefaultCardSprite/Label
@onready var description_label: Label = $SubViewport/DefaultCardSprite/Label2
@onready var c_cost_label: Label = $SubViewport/DefaultCardSprite/Label3
@onready var pe_cost_label: Label = $SubViewport/DefaultCardSprite/Label4
@onready var sprite=$SubViewport/DefaultCardSprite
#@onready var image: TextureRect = %CardImage

func _update_display() -> void:
	var data = card_resource as Gu_Move
	if data:
		name_label.text = data.card_name
		description_label.text = data.card_description
		c_cost_label.text = str(data.c_cost)
		pe_cost_label.text = str(data.pe_cost)
	display_updated.emit()
