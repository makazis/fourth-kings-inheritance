class_name Effect extends Resource
@export var next_effect:Effect=null;

func run():
	pass
func process():
	run()
	
	if next_effect!=null:
		next_effect.process()
