@tool  # Enables layout name enum dropdown in the inspector
class_name Gu_Move extends "res://Card Data/card_super.gd"

@export var parent_gu: Gu_card = null;
@export var pe_cost: int = 1;
@export var c_cost: int = 1;
@export var art: Texture2D
@export var card_name:String=""
@export_multiline var card_description:String=""
@export var effect:Effect=null
@export var target_criteria:TargetCriteria=null
@export var target_count=1; #if it's 0, then everyone is targeted. 
@export var card_tags:Array[Card_Tag]=[]
func is_played():
	if parent_gu!=null:
		parent_gu.gu_move_used(self)
