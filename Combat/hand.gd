extends CardHand

# Called when the node enters the scene tree for the first tim
signal card_played
var wait_till_dropped=0

func _physics_process(delta: float) -> void:
	wait_till_dropped=max(0,wait_till_dropped-1)
	if wait_till_dropped==1:
		CG.dropped_card.emit()
		pass
	if wait_till_dropped>0:
		pass
	if _dragged_card!=null:
		if _dragged_card.card_data.target_criteria!=null and _dragged_card.card_data.target_count==1:
			var closest_distance=INF
			var target_creature=null
			for entity in EffectContext.roles["Fitting Targets"]:
				entity.target_indicator.color=Color(0.0, 0.416, 0.51, 0.388)
				var entity_distance=_dragged_card._last_pos.distance_to(entity.center.global_position)
				if entity_distance<closest_distance:
					target_creature=entity
					closest_distance=entity_distance
			target_creature.target_indicator.color=Color(0.832, 0.315, 0.43, 0.463)
func _handle_dragged_card(card: Card) -> void:
	if card.card_data.c_cost>CombatData.concentration or card.card_data.pe_cost>CombatData.primeval_essence or "Unplayable" in card.card_tag_ids: #Card is not to be played
		wait_till_dropped=2
		#_finish_card_drop.call_deferred(true)
		return
	if card.playable==false:
		#_finish_card_drop.call_deferred(true)
		wait_till_dropped=3
		return
	if card.card_data.target_criteria!=null:
		EffectContext.roles["Fitting Targets"]=[]
		for entity in EffectContext.all_entities:
			if card.card_data.target_criteria.matches(entity.data):
				entity.target_indicator.visible=true
				EffectContext.roles["Fitting Targets"].append(entity)
		if len(EffectContext.roles["Fitting Targets"])==0:
			_finish_card_drop()
			return
		
func _finish_card_drop() -> void:
	if _dragged_card==null:
		return
	var had_followers = not _drag_followers.is_empty()
	var followers_copy: Array[Card] = _drag_followers.duplicate()
	var lead_card = _dragged_card
	lead_card.holding=false
	if lead_card and cards.has(lead_card) and _last_reorder_index != _original_drag_index:
		_sync_card_child_order()
		cards_reordered.emit(cards)
		_handle_reordered_cards(cards)
	for follower in _drag_followers:
		follower.disabled = false

	_drag_followers.clear()
	_follower_shape_offsets.clear()
	for entity in EffectContext.all_entities:
		entity.target_indicator.visible=false
	var card_dragged_for=_dragged_card.global_position.distance_to(get_card_target_position(_dragged_card)+global_position)
	
	if card_dragged_for>400:
		
		
		emit_signal("card_played",_dragged_card)
		
		CombatData.concentration-=_dragged_card.card_data.c_cost
		CombatData.primeval_essence-=_dragged_card.card_data.pe_cost
		CombatData.root_visual_update.emit()
		
		
		EffectContext.roles["Target"]=[]
		if _dragged_card.card_data.target_count==1 and _dragged_card.card_data.target_criteria!=null:
			var closest_distance=INF
			var target_creature=null
			for entity in EffectContext.roles["Fitting Targets"]:
				var entity_distance=_dragged_card._last_pos.distance_to(entity.center.global_position)
				if entity_distance<closest_distance:
					target_creature=entity
					closest_distance=entity_distance
			if target_creature!=null:
				EffectContext.roles["Target"].append(target_creature)
		else:
			for entity in EffectContext.roles["Fitting Targets"]:
				EffectContext.roles["Target"].append(entity)
		await _dragged_card.play()
		if _dragged_card!=null:
			if "Exhaust" in _dragged_card.card_tag_ids:
				print("Exhausted Succesfully")
				move_cards_to([_dragged_card],$"../ExhaustPile")
			else:
				move_cards_to([_dragged_card],$"../DiscardPile")
		#_dragged_card.card_data.effect.process()
		#_dragged_card.card_data.is_played()
	_dragged_card = null
	_drag_start_index = -1
	_last_reorder_index = -1
	_original_drag_index = -1
	_last_reorder_cursor = Vector2.INF
	set_process(false)
	arrange()
	if lead_card and cards.has(lead_card):
		_start_card_idle(lead_card, card_move_duration)
	for follower in followers_copy:
		if cards.has(follower):
			_start_card_idle(follower, card_move_duration)
	if had_followers and lead_card and lead_card.get_parent() != self:
		var target = lead_card.get_parent()
		if target is CardContainer:
			for follower in followers_copy:
				follower.move_to(target)
		
