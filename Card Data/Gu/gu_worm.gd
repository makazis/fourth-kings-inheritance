@tool  # Enables layout name enum dropdown in the inspector
class_name Gu_card extends "res://Card Data/card_super.gd"

@export var gu_name: String = ""
@export var effect_on_gu_move_used:Effect=null
@export var effects_on_start_of_specific_turns:Dictionary[int,Effect]={}
@export_multiline var lore_description:String=""
@export_multiline var combat_description:String=""

func gu_move_used(move:Gu_Move):
	if effect_on_gu_move_used!=null:
		effect_on_gu_move_used.process()
func start_turn(turn_index:int):
	if turn_index in effects_on_start_of_specific_turns:
		effects_on_start_of_specific_turns[turn_index].process()
