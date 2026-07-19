class_name ModifyVariableEffect extends Effect
@export var variable_name:String=""
@export_enum("+","-","*","/","=") var modification:String="+"
@export var second_value:String="" 
## can be a variable, can be a number too :)
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
	var pre_modification_variable=EffectContext.variables[variable_name]
	if modification=="+":
		EffectContext.variables[variable_name]+=other_value
	if modification=="-":
		EffectContext.variables[variable_name]-=other_value
	if modification=="*":
		EffectContext.variables[variable_name]*=other_value
	if modification=="/":
		EffectContext.variables[variable_name]/=other_value
	if modification=="=":
		EffectContext.variables[variable_name]=other_value
	EffectContext.debug_print("Modifying Variable: "+variable_name+" "+modification+" "+second_value+" | "+str(pre_modification_variable)+" "+modification+" "+str(other_value)+" => "+str(EffectContext.variables[variable_name]))
