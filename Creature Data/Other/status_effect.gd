extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var _status=null
func hide_all_icons():
	for i in $Icon.get_children():
		i.visible=false
func setup(status,entity):
	hide_all_icons()
	_status=status
	if status=="Strength":
		$Icon/SwordIcon.visible=true
	elif status=="Dexterity":
		$Icon/ShieldIcon.visible=true
	elif status=="Curse":
		$Icon/CurseIcon.visible=true
	
	update(entity)
func update(entity):
	if not _status in entity.data.statuses:
		queue_free()
		return
	if entity.data.statuses[_status]==0:
		entity.data.statuses.erase(_status)
		queue_free()
		return
	$Label.text=CombatData.standart_big_number(entity.data.statuses[_status])
	
