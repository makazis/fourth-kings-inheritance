extends Node2D

@onready var creature=preload("res://Creature Data/Creature.tscn")
# Called when the node enters the scene tree for the first time.
var drawn_cards=false
var creature_load_reference={
	"Fang Yuan":preload("res://Creature Data/Friends/cultivator.tres"),
	"Spectral Dog":preload("res://Creature Data/Enemies/Ethereal Dog.tres"),
}
func _ready() -> void:
	setup()
	CombatData.root_visual_update.connect(visual_update)
	EffectContext.combat_ends.connect(_on_combat_ends)
	start_the_turn.call_deferred()
	
	pass # Replace with function body.

# f - friendly
# uf - unfriendly
var f_space_x=0
var f_space_y=0 
var f_y_window_size=0
var uf_space_x=0
var uf_space_y=0 
var uf_y_window_size=0
##These six values denote where will new entities be placed. 

func setup():
	var main_character=creature.instantiate()
	main_character.data=creature_load_reference["Fang Yuan"].duplicate() # use when creating characters
	EffectContext.roles["Caster"]=[main_character]
	var enemies=[]
	for i in range(1):
		var temp_enemy=creature.instantiate()
		temp_enemy.data=creature_load_reference["Spectral Dog"].duplicate()
		enemies.append(temp_enemy)
	setup_entities([main_character],enemies)
func create_creature(creature_data) -> Creature_Node:
	var temp_enemy=creature.instantiate()
	temp_enemy.data=creature_data.duplicate()
	return temp_enemy
func summon_entity(_creature:Creature_Node):
	_creature.combat_root=self
	if _creature.data.team=="Friendly":
		var random_x_bonus=randi_range(0,100)
		var random_y_bonus=randi_range(0,100) 
		## The two above values signify the x and y offset when loading in the character.
		if 256*_creature.data.display_size+200>f_y_window_size:
			var t1=f_y_window_size!=0
			f_y_window_size=256*_creature.data.display_size+200
			if t1:
				f_space_y-=f_y_window_size
			f_space_x=0
		if f_space_x+_creature.data.display_size*256+random_x_bonus>1124: #less than the width of the scroll area
			f_space_x=0
			var t1=f_y_window_size!=0
			f_y_window_size=256*_creature.data.display_size+200
			if t1:
				f_space_y-=f_y_window_size
		_creature.position.x=f_space_x+random_x_bonus
		_creature.position.y=f_space_y+random_y_bonus
		f_space_x+=_creature.data.display_size*256+random_x_bonus
		$"Friendly Characters/Friends".add_child(_creature)
	else:
		var random_x_bonus=randi_range(0,100)
		var random_y_bonus=randi_range(0,100) 
		## The two above values signify the x and y offset when loading in the character.
		if uf_y_window_size==0:
			uf_y_window_size=256*_creature.data.display_size+200
		elif 256*_creature.data.display_size+200>uf_y_window_size:
			uf_space_y-=uf_y_window_size
			uf_y_window_size=256*_creature.data.display_size+200
			uf_space_x=0
		if uf_space_x+_creature.data.display_size*256+random_x_bonus>1124: #less than the width of the scroll area
			uf_space_x=0
			uf_space_y-=uf_y_window_size
			uf_y_window_size=256*_creature.data.display_size+200
		_creature.position.x=uf_space_x+random_x_bonus
		_creature.position.y=uf_space_y+random_y_bonus
		uf_space_x+=_creature.data.display_size*256+random_x_bonus
		$"UnFriendly Characters/Friends".add_child(_creature)
func setup_entities(Friendly,Enemy): #expects 2 arrays of creature nodes, but breaks if it's added in the code, idk why
	for entity in EffectContext.all_entities:
		entity.queue_free()
	EffectContext.all_entities.clear()
	for iter_friendly_entity in Friendly:
		summon_entity(iter_friendly_entity)
		
	
	for iter_unfriendly_entity in Enemy:
		summon_entity(iter_unfriendly_entity)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.


func start_the_turn():
	CombatData.turn+=1
	CombatData.concentration=CombatData.max_concentration
	
	$Deck.deal_to($Hand,5)
	CombatData.start_turn.emit(CombatData.turn)
	visual_update()
func end_the_turn():
	
	for entity in EffectContext.all_entities:
		if entity.data.team!="Friendly":
			entity.data.block=0
	CombatData.end_turn.emit(CombatData.turn)
	for card in $Hand.cards:
		for tag in card.card_tags:
			await tag.on_end_of_turn(card)
	$Hand.deal_to($DiscardPile,$Hand.get_card_count())
	$Timer.start()
	
func visual_update():
	$Energy/Conc/MaxConcentration.text=CombatData.standart_big_number(CombatData.max_concentration)
	$Energy/Conc/Concentration.text=CombatData.standart_big_number(CombatData.concentration)
	$Energy/Essence/MaxConcentration.text=CombatData.standart_big_number(CombatData.max_primeval_essence)
	$Energy/Essence/Concentration.text=CombatData.standart_big_number(CombatData.primeval_essence)
	
func draw_cards(card_count:int=1):
	for i in range(card_count):
		await get_tree().create_timer(0.2).timeout
		$Deck.deal_to($Hand,1)
		$Hand.arrange()
func create_card_in(card_resource:CardResource,card_pile:String="Hand"):
	var card = Card.new(card_resource)
	if card_pile=="Hand":
		card.move_to($Hand, Card.MoveConfig.new(0))
	if card_pile=="DiscardPile":
		card.move_to($DiscardPile, Card.MoveConfig.new(0))
	if card_pile=="Deck":
		card.move_to($Deck, Card.MoveConfig.new(0))
	
func _on_texture_button_button_up() -> void:
	end_the_turn()



func _on_timer_timeout() -> void:
	for entity:Creature_Node in EffectContext.all_entities:
		#await get_tree().create_timer(0.5).timeout
		await entity.execute_attack()
	start_the_turn()

func _on_combat_ends():
	pass
	#usually end of combat stuff would go here but for now we just send it back to the main screen. 

var mouse_over_friendly_area=false
var dragging_friendly_area=false
var mouse_over_unfriendly_area=false
var dragging_unfriendly_area=false
var last_mouse_pos=Vector2(0,0)
func _process(delta: float) -> void:
	var new_mouse_pos=get_viewport().get_mouse_position()
	var mouse_rel=new_mouse_pos-last_mouse_pos
	if mouse_over_friendly_area:
		if Input.is_action_just_pressed("lmb"):
			dragging_friendly_area=true
		if Input.is_action_just_released("lmb"):
			dragging_friendly_area=false
		if dragging_friendly_area:
			$"Friendly Characters".position.y=clamp($"Friendly Characters".position.y+mouse_rel[1]*2,f_space_y+602,602)
			for entity in EffectContext.all_entities:
				entity.update_target_line()
	if mouse_over_unfriendly_area:
		if Input.is_action_just_pressed("lmb"):
			dragging_unfriendly_area=true
		if Input.is_action_just_released("lmb"):
			dragging_unfriendly_area=false
		if dragging_unfriendly_area:
			$"UnFriendly Characters".position.y=clamp($"UnFriendly Characters".position.y+mouse_rel[1]*2,f_space_y+602,602)
			for entity in EffectContext.all_entities:
				entity.update_target_line()
	
	last_mouse_pos=new_mouse_pos
	
func _on_drag_area_mouse_entered() -> void:
	mouse_over_friendly_area=true
	
func _on_drag_area_mouse_exited() -> void:
	mouse_over_friendly_area=false
	dragging_friendly_area=false


func _on_drag_area2_mouse_entered() -> void:
	mouse_over_unfriendly_area=true


func _on_drag_area2_2_mouse_exited() -> void:
	mouse_over_unfriendly_area=false
	dragging_unfriendly_area=false
