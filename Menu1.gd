extends MarginContainer


var drag_pos = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MenuDrag_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			drag_pos = get_global_mouse_position() - rect_global_position
		else:
			drag_pos = null
		
		
	if event is InputEventMouseMotion:
		if drag_pos:
			rect_global_position = get_global_mouse_position() - drag_pos
