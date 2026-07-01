extends Node2D

func setup(type="Attack",ammount=1,times=1,effect_type="Weakness"):
	$Label.text=CombatData.standart_big_number(ammount)
	if times>1:
		$Label.text+="x"+CombatData.standart_big_number(times)
	if type=="Attack":
		$Attack.visible=true
	if type=="Block":
		$Defend.visible=true
	if type=="Curse":
		$NegStatus.visible=true
		$Label.text=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
