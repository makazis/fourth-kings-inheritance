extends Node

var primeval_essence=3
var max_primeval_essence=3
var concentration=3
var max_concentration=3
var turn=0


signal card_played(card:Card)
signal card_drawn(card:Card)
signal root_visual_update()
signal start_turn(turn_index:int)

func standart_big_number(num:int):
	for i in range(11):
		if num<pow(1000,i+1):
			return str(num)+["","K","M","B","q","Q","s","S","O","N","D"][i]
	return "∞"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
