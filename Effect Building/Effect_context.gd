extends Node

var roles={
	"Caster":[], #Characters that are performing this specific action (idk, might be an effect that requires multiple casters, like a joint attack)
	"Defender":[], #Characters that are targeted during an action. 
	"Damaged":[], #Characters that are damaged via a certain action. 
	"Fitting Targets":[], #Characters that match the target criteria of a card's activation. 
}; #This will be a dictionary with dynamically assigned targets for cards. 
#An example would be 'Attacker' being assigned to the creature attacking a different creature.
#or perhaps 'Defender' being assigned to the creature who is being attacked via the attack. This does mean that if there are multiple 

#We would also need to make reactions a thing, but that would more likely be a thing that creatures would have, as a reaction to an effect going through the roles, getting processed, etc. 
#This is also why effects are in a seperate folder. 
signal combat_ends

var won=false
var all_entities=[] #Just a set containing every entity that is loaded in game. 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
var saved_entity_data={}

func check_if_combat_ends():
	var friendlies=0
	var enemies=0
	for entity in all_entities:
		if entity.data.team=="Friendly":
			friendlies+=1
		else:
			enemies+=1
	if friendlies==0 or enemies==0:
		
		won=friendlies>0
		for entity in all_entities:
			entity.queue_free()
		all_entities.clear()
		combat_ends.emit()
