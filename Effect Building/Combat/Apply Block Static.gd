class_name ApplyBlockEffect extends Effect
@export var target:String="Defender"
@export var block=0;
func run():
	for iter_target_atk in EffectContext.roles["Caster"]:
		for iter_target_def in EffectContext.roles[target]:
			CombatFunctions.apply_block(iter_target_def.data,iter_target_atk.data,block)
			iter_target_def.visual_update()
		iter_target_atk.visual_update()
