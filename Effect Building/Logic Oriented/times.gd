class_name TimesEffect extends Effect
## Executes an effect multiple times
@export var execute:Effect=null
## Effect that is executed every time
@export var times:int=1;
## How many times does the effect take place
func run():
	for i in range(times):
		execute.process()
