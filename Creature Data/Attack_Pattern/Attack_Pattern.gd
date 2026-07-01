@tool
class_name AttackPattern extends Resource

@export_enum("None","Random","Cycle","Random+") var PatternType:String
@export var attacks:Array[EnemyAttackMove]
