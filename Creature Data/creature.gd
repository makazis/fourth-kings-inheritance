class_name Creature_Node extends Node2D

@export var data:Creature=null;

var max_hp=0
var trig_flag=true



@onready var marker=$Marker2D
@onready var target_indicator=$ColorRect



#Logic related methods
func on_start_turn(turn_index:int):
	if turn_index==1:
		first_attack()
	else:
		next_attack()
	print("SOT: ",turn_index)
	if data.team=="Friendly":
		data.block=0
	visual_update()
	

var attack_data:EnemyAttackMove=null # a list containing every current action on runtime. 
var attack_counter=0 # used for Cycle attack pattern
var last_attack=0 # used for 

#called on first attack, loads first attack and displays it
func first_attack():
	if data.attack_pattern==null:
		return
	if data.attack_pattern.PatternType=="None":
		return
	if data.attack_pattern.PatternType=="Cycle":
		attack_data=data.attack_pattern.attacks[0]
		attack_counter=0
	if data.attack_pattern.PatternType=="Random":
		attack_data=data.attack_pattern.attacks.pick_random()
	if data.attack_pattern.PatternType=="Random+":
		last_attack=randi_range(0,len(data.attack_pattern.attacks)-1)
		attack_data=data.attack_pattern.attacks[last_attack]
	render_attack()

#loads every subsequent attack, and displays it
func next_attack():
	if data.attack_pattern==null:
		return
	if data.attack_pattern.PatternType=="None":
		return
	if data.attack_pattern.PatternType=="Cycle":
		attack_counter+=1
		attack_counter=attack_counter%len(data.attack_pattern.attacks)
		attack_data=data.attack_pattern.attacks[attack_counter]
	if data.attack_pattern.PatternType=="Random":
		attack_data=data.attack_pattern.attacks.pick_random()
	if data.attack_pattern.PatternType=="Random+":
		var temp_last_attack=randi_range(0,len(data.attack_pattern.attacks)-2)
		if temp_last_attack>=last_attack:
			temp_last_attack+=1
		last_attack=temp_last_attack
		attack_data=data.attack_pattern.attacks[last_attack]
	render_attack()
@onready var AttackIndicator=preload("res://Creature Data/Other/attack_indicator.tscn")
var cached_actions=[]
#renders the current attack
func render_attack():
	for i in cached_actions:
		i.queue_free()
	cached_actions.clear()
	var y=0
	for attack_iter in attack_data.actions:
		var temp_action=AttackIndicator.instantiate()
		temp_action.setup(attack_iter.type,attack_iter.amount,attack_iter.times,attack_iter.curse_type)
		add_child(temp_action)
		cached_actions.append(temp_action)
		y-=44 #44 pixels above the last icon is good enough
		temp_action.position=Vector2(30,y)

@export var target:Creature_Node=null
func execute_attack():
	if attack_data==null or target==null:
		return
	for action_iter in attack_data.actions:
		if action_iter.type=="Attack":
			CombatFunctions.deal_damage(data,target.data,action_iter.amount,action_iter.times)
			target.visual_update()
		if action_iter.type=="Block":
			CombatFunctions.apply_block(data,data,action_iter.amount,action_iter.times)
			visual_update()
		if action_iter.type=="Curse":
			pass
		if action_iter.type=="Buff":
			pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(EffectContext.all_entities,self)
	max_hp=data.hp
	$Sprite2D.texture=data.image
	visual_update()
	EffectContext.all_entities.append(self)
	CombatData.start_turn.connect(on_start_turn)
func visual_update():
	$ProgressBar.value=float(data.hp)/max_hp*100.
	$ProgressBar/Label.text="%d/%d" % [data.hp,max_hp]
	if data.block>0:
		$ProgressBar.texture_progress.gradient.set_color(0,Color(0.275, 0.275, 0.275, 1.0))
		$ProgressBar.texture_progress.gradient.set_color(1,Color(0.561, 0.561, 0.561, 1.0))
		$ShieldIcon.visible=true
		$ShieldIcon/ShieldLabel.text=CombatData.standart_big_number(data.block)
	else:
		$ShieldIcon.visible=false
		$ProgressBar.texture_progress.gradient.set_color(0,Color(0.49, 0.0, 0.0, 1.0))
		$ProgressBar.texture_progress.gradient.set_color(1,Color(1.0, 0.0, 0.0, 1.0))
	if data.hp<=0:
		queue_free()

func _exit_tree() -> void:
	EffectContext.all_entities.erase(self)
	EffectContext.check_if_combat_ends()
#func _process(delta: float) -> void:
#	visual_update()
