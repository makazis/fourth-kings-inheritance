class_name CreateCardEffect extends Effect
@export var created_card_data:Gu_Move=null
@export_enum("Deck","Hand","Discard Pile") var place_where:String="Hand"
func run():
	#for iter_target in EffectContext.roles["Caster"]:
	EffectContext.roles["Caster"][0].combat_root.create_card_in(created_card_data,place_where)
