extends Node

func deal_damage(attacker:Creature,defender:Creature,damage:int,times:int=1):
	var total_damage=damage
	total_damage*=times
	defender.block-=total_damage
	if defender.block<0:
		defender.hp+=defender.block
		defender.block=0

func apply_block(target:Creature,source:Creature,block:int,times:int=1):
	target.block+=block*times
