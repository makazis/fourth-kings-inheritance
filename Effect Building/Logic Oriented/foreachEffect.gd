class_name ForEachEffect extends Effect
## Counts entites that fit a criteria, and executes the 
@export var target_criteria:TargetCriteria=null
## Criteria denoting which creatures are counted when this effect is processed
@export var execute:Effect=null
## Effect that is executed for each entity found that matches the criteria. Note that each entity will have the 'ForEach' role in case it is needed during the executed effect
func run():
	for entity in EffectContext.all_entities:
		if target_criteria.matches(entity.data):
			EffectContext.roles["ForEach"]=entity
			execute.process()
