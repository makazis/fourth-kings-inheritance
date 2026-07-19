class_name DrawCardEffect extends Effect
@export var cards_drawn:int=1
func run():
	for iter_target in EffectContext.roles["Caster"]:
		EffectContext.debug_print("Drawing "+str(cards_drawn)+" Cards")
		await iter_target.combat_root.draw_cards(cards_drawn)
