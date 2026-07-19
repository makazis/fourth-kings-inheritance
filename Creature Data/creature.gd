class_name Creature_Node extends Node2D

@export var data:Creature=null;

var max_hp=0
var trig_flag=true

var _scale=1


@onready var center=$S/Center
@onready var target_indicator=$S/ColorRect
var combat_root:Node2D=null

var default_position=position

#Logic related methods
func on_start_turn(turn_index:int):
	if turn_index==1:
		first_attack()
	else:
		next_attack()
	if data.team=="Friendly":
		data.block=0
		individual_start_turn()
	else:
		individual_end_turn()
	visual_update()

func on_end_turn(turn_index:int):
	if data.team=="Friendly":
		individual_end_turn()
	else:
		individual_start_turn()

func individual_start_turn(turn_index:int=0):
	var needs_to_update_status_effects=false
	if data.team=="Friendly":
		
		if !data.main_character:
			var valid_targets=[]
			for entity in EffectContext.all_entities:
				if entity.data.team=="Enemy":
					valid_targets.append(entity)
			target=valid_targets.pick_random()
			render_attack()
				#$S/Line2D.set_point_position(0,(center.position/2.*_scale))
	### Add function body here
	
	if needs_to_update_status_effects:
		update_status_effects()
func individual_end_turn():
	var needs_to_update_status_effects=false
	if "Shackle" in data.statuses:
		if not "Strength" in data.statuses:
			data.statuses["Strength"]=0
		data.statuses["Strength"]+=data.statuses["Shackle"]
		data.statuses["Shackle"]=0
		needs_to_update_status_effects=true
	if data.team=="Enemy":
		var valid_targets=[]
		for entity in EffectContext.all_entities:
			if entity.data.team=="Friendly":
				valid_targets.append(entity)
		target=valid_targets.pick_random()
		render_attack()
		#targets=[0]
		#update_target_line()
	if needs_to_update_status_effects:
		update_status_effects()
var attack_data:EnemyAttackMove=null # a list containing every current action on runtime. 
var attack_counter=0 # used for Cycle attack pattern
var last_attack=0 # used for 

var action_is_helpful=true
## Variable that determines whether or not an action will harm the individual, or will it help them instead (mostly for enemy AI)
#called on first attack, loads first attack and displays it
func first_attack():
	if data.attack_pattern==null:
		return
	if data.attack_pattern.PatternType=="None":
		return
	
	var valid_targets=[]
	for entity in EffectContext.all_entities:
		if entity.data.team=="Friendly":
			valid_targets.append(entity)
	target=valid_targets.pick_random()
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
var targets=[]
@onready var AttackIndicator=preload("res://Creature Data/Other/attack_indicator.tscn")
var cached_actions=[]
#renders the current attack
func render_attack():
	if data.main_character:
		return
	if attack_data==null:
		return
	for i in cached_actions:
		i.queue_free()
	cached_actions.clear()
	var y=0
	targets.clear()
	
	for attack_iter in attack_data.actions:
		var temp_action=AttackIndicator.instantiate()
		temp_action.setup(self,attack_iter.type,attack_iter.amount,attack_iter.times,attack_iter.status_type)
		add_child(temp_action)
		cached_actions.append(temp_action)
		y-=44 #44 pixels above the last icon is good enough
		temp_action.position=Vector2(30,y)
		if attack_iter.type=="Attack":
			targets.append(target)
	update_target_line()
func update_target_line():
	if target!=null and len(targets)>0:
		$Line2D.set_point_position(1,((target.center.global_position-center.global_position)))
	else:
		$Line2D.set_point_position(1,Vector2(0,0))
var target:Creature_Node=null
signal attack_finished()

func execute_attack():
	if attack_data==null or target==null:
		return
	action_is_helpful=true
	for action_iter in attack_data.actions:
		if action_iter.type in ["Attack","Curse"]:
			action_is_helpful=false
	if attack_data.override_helpful=="Helpful":
		action_is_helpful=true
	elif attack_data.override_helpful=="Harmful":
		action_is_helpful=false
	
	for action_iter in attack_data.actions:
		var iteratable_targets=[]
		var tween=create_tween()
		if action_is_helpful:
			iteratable_targets=[self]
		else:
			iteratable_targets=[target]
		for i in action_iter.times:
			
			#await get_tree().create_timer(0.2).timeout
			if not (action_iter.target_perhaps==null or action_iter.target_perhaps==""):
				iteratable_targets=EffectContext.roles[action_iter.target_perhaps]
			for iter_target in iteratable_targets:
				if iter_target==null:
					continue
				if action_iter.type=="Attack":
					var offset_vector=Vector2(-70,0)
					if data.team=="Friendly":
						offset_vector=Vector2(70,0)
					var og_pos=$S.position
					tween=create_tween()
					tween.tween_property($S,"position",og_pos+offset_vector,0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

					await tween.finished
					CombatFunctions.deal_damage(data,iter_target.data,action_iter.amount)
					tween=create_tween()
					tween.tween_property($S,"position",og_pos,0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
					await tween.finished
					iter_target.visual_update()
				if action_iter.type=="Block":
					CombatFunctions.apply_block(iter_target.data,data,action_iter.amount)
					visual_update()
				if action_iter.type=="Curse" or action_iter.type=="Buff":
					var t1=not action_iter.status_type in iter_target.data.statuses
					CombatFunctions.apply_status(iter_target.data,data,action_iter.status_type,action_iter.amount)
					if t1:
						iter_target.add_new_status_effect_visual(action_iter.status_type)
					iter_target.update_status_effects()
					visual_update()
	attack_finished.emit()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_hp=data.hp
	$S.texture=data.image
	
	## Setting the size correctly
	_scale=data.display_size
	$S.scale=Vector2(data.display_size,data.display_size)
	$Line2D.set_point_position(0,$S/Center.position*_scale-$Line2D.position)
	visual_update()
	EffectContext.all_entities.append(self)
	if not data.team in EffectContext.roles:
		EffectContext.roles[data.team]=[]
	EffectContext.roles[data.team].append(self)
	CombatData.start_turn.connect(on_start_turn)
	CombatData.end_turn.connect(on_end_turn)

func visual_update():
	$S/ProgressBar.value=float(data.hp)/max_hp*100.
	$S/ProgressBar/Label.text="%d/%d" % [data.hp,max_hp]
	if data.block>0:
		$S/ProgressBar.texture_progress.gradient.set_color(0,Color(0.275, 0.275, 0.275, 1.0))
		$S/ProgressBar.texture_progress.gradient.set_color(1,Color(0.561, 0.561, 0.561, 1.0))
		$S/ShieldIcon.visible=true
		$S/ShieldIcon/ShieldLabel.text=CombatData.standart_big_number(data.block)
	else:
		$S/ShieldIcon.visible=false
		$S/ProgressBar.texture_progress.gradient.set_color(0,Color(0.49, 0.0, 0.0, 1.0))
		$S/ProgressBar.texture_progress.gradient.set_color(1,Color(1.0, 0.0, 0.0, 1.0))
	if data.hp<=0:
		queue_free()
##Status effect visual functions
func update_status_effects():
	for iter_status in  $S/GridContainer.get_children():
		iter_status.update(self)
	render_attack()
@onready var status_effect=preload("res://Creature Data/Other/status_effect.tscn")
func add_new_status_effect_visual(status):
	var temp_status_effect=status_effect.instantiate()
	temp_status_effect.setup(status,self)
	$S/GridContainer.add_child(temp_status_effect)

func _exit_tree() -> void:
	EffectContext.all_entities.erase(self)
	EffectContext.roles[data.team].erase(self)
	EffectContext.check_if_combat_ends()

	
