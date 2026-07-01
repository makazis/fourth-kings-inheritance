@tool
class_name PatternAction extends Resource
@export_enum("Attack","Block","Curse") var type:String
@export var amount:int=5
@export var times:int=1
@export var curse_type:String="Weakness"
