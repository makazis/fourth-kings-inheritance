class_name CheckVariableEffect extends Effect
## Checks if a variable fufills a condition, and executes an effect if it does 
@export var variable_name:String=""
@export_enum("=",">","<",">=","<=","!=","%=0") var match_condition:String="="
@export var second_value:String="" # can be a variable, can be a number too :)
## Criteria denoting which creatures are counted when this effect is processed
@export var execute:Effect=null
## Effect that is executed if the condition is matched
func run():
	if not variable_name in EffectContext.variables:
		EffectContext.variables[variable_name]=0
	var is_number=true
	for i in second_value:
		if i in "-1234567890":
			continue
		is_number=false
	var other_value=0
	if is_number:
		other_value=int(second_value)
	else:
		if not second_value in EffectContext:
			EffectContext.variables[second_value]=0
		other_value=EffectContext.variables[second_value]
	var matching=false
	if match_condition=="%=0":
		if EffectContext.variables[variable_name]%other_value==0:
			matching=true
		EffectContext.debug_print("Checking Variable: "+variable_name+" % "+second_value+" ==0 | "+str(EffectContext.variables[variable_name])+" % "+str(other_value)+" ==0 so "+str(matching))
	
	elif match_condition=="=":
		if EffectContext.variables[variable_name]==other_value:
			matching=true
	elif match_condition==">":
		if EffectContext.variables[variable_name]>other_value:
			matching=true
	elif match_condition=="<":
		if EffectContext.variables[variable_name]<other_value:
			matching=true
	elif match_condition==">=":
		if EffectContext.variables[variable_name]>=other_value:
			matching=true
	elif match_condition=="<=":
		if EffectContext.variables[variable_name]<=other_value:
			matching=true
	elif match_condition=="!=":
		if EffectContext.variables[variable_name]!=other_value:
			matching=true
	EffectContext.debug_print("Checking Variable: "+variable_name+" "+match_condition+" "+second_value+" | "+str(EffectContext.variables[variable_name])+" "+match_condition+" "+str(other_value)+" so "+str(matching))
	if matching:
		execute.process()
