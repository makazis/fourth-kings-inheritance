@tool
class_name Creature extends Resource

@export var name:String="";
@export var display_size:int=1;
@export var hp:int=10;

@export var block:int=0; #like that one orb enemy in sts that starts with block. 

@export var image: Texture2D
@export_enum("Friendly","Enemy","Neutral") var team:String #Neutral means it can be targeted by both

@export var attack_pattern:AttackPattern
@export var main_character:bool=false


var statuses={}
