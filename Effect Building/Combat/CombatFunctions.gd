extends Node

func deal_damage(attacker:Creature,defender:Creature,damage:int,times:int=1):
	var total_damage=damage
	if "Strength" in attacker.statuses:
		total_damage+=attacker.statuses["Strength"]
	total_damage*=times
	defender.block-=total_damage
	if defender.block<0:
		defender.hp+=defender.block
		defender.block=0

func apply_block(target:Creature,source:Creature,block:int,times:int=1):
	var gained_block=block
	if "Dexterity" in source.statuses:
		gained_block+=source.statuses["Dexterity"]
	target.block+=gained_block*times
func apply_status(target:Creature,source:Creature,_type:String,amount:int=1,times:int=1):
	if not _type in target.statuses:
		target.statuses[_type]=0
	target.statuses[_type]+=amount*times
