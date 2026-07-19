class_name RandomChanceEvent extends Effect
## Counts entites that fit a criteria, and executes the 
@export var chance:float=0.5
## Chance that event triggers
@export var execute:Effect=null
## Effect that is executed on random chance triggering
func run():
	var r=randf()
	if r<chance:
		execute.process()
