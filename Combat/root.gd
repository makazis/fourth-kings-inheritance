extends Node2D


# Called when the node enters the scene tree for the first time.
var drawn_cards=false
func _ready() -> void:
	print("YO")
	CombatData.root_visual_update.connect(visual_update)
	EffectContext.combat_ends.connect(_on_combat_ends)
	start_the_turn.call_deferred()
	$Doggo.target=$"Fang Yuan"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_the_turn():
	CombatData.turn+=1
	CombatData.concentration=CombatData.max_concentration
	CombatData.primeval_essence=CombatData.max_primeval_essence
	
	$Deck.deal_to($Hand,5)
	CombatData.start_turn.emit(CombatData.turn)
	visual_update()
func end_the_turn():
	for entity in EffectContext.all_entities:
		if entity.data.team!="Friendly":
			entity.data.block=0
	$Hand.deal_to($DiscardPile,$Hand.get_card_count())
	$Timer.start()

func visual_update():
	$Energy/Conc/MaxConcentration.text=CombatData.standart_big_number(CombatData.max_concentration)
	$Energy/Conc/Concentration.text=CombatData.standart_big_number(CombatData.concentration)
	$Energy/Essence/MaxConcentration.text=CombatData.standart_big_number(CombatData.max_primeval_essence)
	$Energy/Essence/Concentration.text=CombatData.standart_big_number(CombatData.primeval_essence)
	


func _on_texture_button_button_up() -> void:
	end_the_turn()



func _on_timer_timeout() -> void:
	for entity in EffectContext.all_entities:
		entity.execute_attack()
	start_the_turn()

func _on_combat_ends():
	print("Combat ended?")
	queue_free()
