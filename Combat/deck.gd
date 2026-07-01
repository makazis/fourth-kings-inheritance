extends CardPile

func deal_to(target: CardContainer, count: int, config: Card.MoveConfig = null) -> int:
	if !config: config = Card.MoveConfig.new()
	var use_batch = config.batch or config.duration == 0
	if use_batch:
		target._batch_mode = true

	var dealt: int = 0
	for i in count:
		if cards.is_empty():
			$"../DiscardPile".move_all_to(self)
		var card = cards.back()
		if !target.can_accept_card(card): break
		card.move_to(target, config)
		dealt += 1
		if config.stagger > 0.0 and i < count - 1:
			await get_tree().create_timer(config.stagger).timeout

	if use_batch and dealt > 0:
		target._batch_mode = false
		var settle_dur: float = config.duration if config.duration >= 0.0 else target.card_move_duration
		target.arrange(settle_dur)
		target._schedule_idle_restart(settle_dur)
	elif use_batch:
		target._batch_mode = false

	return dealt
