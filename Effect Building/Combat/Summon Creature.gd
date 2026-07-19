class_name SummonCreatureEffect extends Effect
@export var creature_data:Creature=null
func run():
	EffectContext.roles["Summon"]=[]
	for caster in EffectContext.roles["Caster"]:
		var temp_entity=caster.combat_root.create_creature(creature_data)
		#temp_entity.data=creature_data.duplicate()
		EffectContext.roles["Summon"].append(temp_entity)
		caster.combat_root.summon_entity(temp_entity)
