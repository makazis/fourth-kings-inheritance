class_name TargetAny extends Effect

@export var target_criteria:TargetCriteria=null
@export var assigned_role:String="Target"
#WHat types of targets would i want?? 
#I think target single character (usually only enemy characters for simplicity), meaning single target. 
#Oooh, actually, make the targeting system where you can choose from valid targets, that match criteria should be best. 
#And then you can choose not 

var valid_targets=[]
func run():
	valid_targets=[]
	for entity in EffectContext.all_entities:
		if target_criteria.matches(entity):
			valid_targets.append(entity)
	run_targeting_scene()
	
	
func run_targeting_scene():
	pass

func assign():
	EffectContext.roles[assigned_role]=valid_targets
