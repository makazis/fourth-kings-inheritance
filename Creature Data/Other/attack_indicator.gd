extends Node2D

func setup(parent:Creature_Node,type="Attack",ammount=1,times=1,effect_type="Strength",):
	var total_ammount=ammount
	
	if type=="Attack":
		$Attack.visible=true
		if "Strength" in parent.data.statuses:
			total_ammount+=parent.data.statuses["Strength"]
	if type=="Block":
		$Defend.visible=true
		if "Dexterity" in parent.data.statuses:
			total_ammount+=parent.data.statuses["Dexterity"]
	
	$Label.text=CombatData.standart_big_number(total_ammount)
	if times>1:
		$Label.text+="x"+CombatData.standart_big_number(times)
	if type=="Curse":
		$NegStatus.visible=true
		$Label.text=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
