class_name TargetCriteria extends Resource
@export_enum("Any","Friendly","Enemy") var team:String="Any" #Any means any character can be targeted with an effect
@export var role:String="";
## Roles that are targeted. Leave blank to target all roles. 
@export var except:TargetCriteria=null #Target criteria that if it matches entity, it unmatches the entity
func matches(entity:Creature):
	#Imma do some never nesting here, because yipii
	if team=="Friendly":
		if not (entity.team=="Friendly" or entity.team=="Neutral"):
			return false
	if team=="Enemy":
		if not (entity.team=="Enemy" or entity.team=="Neutral"):
			return false
	
		
	if !role=="":
		if not entity in EffectContext.roles[role]:
			return false
			
			
	if except!=null:
		if except.matches(entity):
			return false
			
			
	return true
