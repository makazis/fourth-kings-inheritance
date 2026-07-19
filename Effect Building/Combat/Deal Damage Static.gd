class_name DealDamageEffect extends Effect
@export var target:String="Target"
@export var damage=0;
func run():
	for iter_target_atk in EffectContext.roles["Caster"]:
		for iter_target_def in EffectContext.roles[target]:
			CombatFunctions.deal_damage(iter_target_atk.data,iter_target_def.data,damage)
			iter_target_def.visual_update()
		iter_target_atk.visual_update()
	
