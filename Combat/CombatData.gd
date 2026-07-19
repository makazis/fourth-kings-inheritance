extends Node

var primeval_essence=3
var max_primeval_essence=3
var concentration=3
var max_concentration=3
var turn=0

## Variables that stay between combats:
var player_hp=70
var player_companions=[] # a list containing data of every companion that the player has. 
var player_gu_worms:Array[Gu_card]=[load("res://Card Data/Gu/Strength Path/Dog Strength Gu/dog_strength_gu.tres"),load("res://Card Data/Gu/Strength Path/one jin strength gu/jin_strength_gu.tres")]

signal card_played(card:Card)
signal card_drawn(card:Card)
signal root_visual_update()
signal start_turn(turn_index:int)
signal end_turn(turn_index:int)

var short_pause=false

func standart_big_number(num:int):
	for i in range(11):
		if num<pow(1000,i+1):
			return str(int(num/pow(1000.,i)))+["","K","M","B","q","Q","s","S","O","N","D"][i]
	return "∞"
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	start_turn.connect(gu_worm_start_of_turn_effects)
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gu_worm_start_of_turn_effects(turn_number:int):
	for worm in player_gu_worms:
		worm.start_turn(turn_number)
