extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EffectContext.combat_ends.connect(_on_combat_ends)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$Camera2D.position.x+=2560.0
	pass # Replace with function body.

func _on_combat_ends():
	print("Combat Ended")
	$Camera2D.position.x-=2560.0
