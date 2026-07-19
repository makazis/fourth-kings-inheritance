class_name ApplyStatusEffect extends Effect
@export var target:String="Target"
@export var amount:int=1;
@export_enum("Strength","Dexterity","Shackle") var status_effect:String="Strength"
@export var times:int=1;
## Very rarely used, not advised normally
func run():
	for iter_target_caster in EffectContext.roles["Caster"]:
		for iter_target_casted_on in EffectContext.roles[target]:
			var t1=not status_effect in iter_target_casted_on.data.statuses
			CombatFunctions.apply_status(iter_target_casted_on.data,iter_target_caster.data,status_effect,amount,times)
			if t1:
				iter_target_casted_on.add_new_status_effect_visual(status_effect)
			iter_target_casted_on.update_status_effects()
			iter_target_casted_on.visual_update()
		#iter_target_caster.visual_update()
