@tool
class_name EnemyAttackMove extends Resource

@export var actions:Array[PatternAction]
@export var name:String="UnnamedAttack"
@export_enum("Don't","Helpful","Harmful") var override_helpful:String="Don't"
