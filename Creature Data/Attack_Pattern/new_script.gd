@tool
class_name PatternAction extends Resource
@export_enum("Attack","Block","Curse","Buff") var type:String
@export var amount:int=5
@export var times:int=1
@export var status_type:String="Strength"
@export var target_perhaps:String=""
