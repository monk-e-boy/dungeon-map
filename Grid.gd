extends Node2D

class_name Grid

signal create_room(x, y)
signal create_vwall(x, y)
signal create_hwall(x, y)

var highlight = false;
var pointer = Vector2(0,0)
var show_pointer = true
var mouse_pos = Vector2(0,0)
var color = Color.tomato;
var size = 1

var mode_room = 0
var mode_wall = 1
var mode = mode_room

func _ready():
	var n = get_tree().get_root().get_node("Application")
	size = n.square_size_px()

func _process(delta):
	pass

func _input(event):
	#print("Input event")
	pass

# ignore GUI clicks on toolbar
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		self.mouse_pos = event.position
		self.update()
		
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			# left click mouse up
			# floor and int - remove all those anoying 1/2 pixel sizes
			var x = int(floor( floor(self.mouse_pos.x / size) * size ) )
			var y = int(floor( floor(self.mouse_pos.y / size) * size ) )
				
			if mode == mode_room:
				emit_signal("create_room", x, y)
				
			if mode == mode_wall:
				create_wall(x, y)
		

func create_wall(x, y):
	var rooms = get_node("../Rooms").get_children()
	for room in rooms:
		# LEFT
		var r = Rect2(Vector2(room.pos.x-4, room.pos.y), Vector2(8, room.size))
		if r.has_point(mouse_pos):
			emit_signal("create_vwall", room.pos.x-4, room.pos.y)
			break
		
#		# RIGHT
#		r = Rect2(Vector2(room.pos.x+room.size-4, room.pos.y), Vector2(8, room.size))
#		if r.has_point(mouse_pos):
#			emit_signal("create_vwall", x, y)
#			break
		
		# TOP
		r = Rect2(Vector2(room.pos.x, room.pos.y-4), Vector2(room.size, 8))
		if r.has_point(mouse_pos):
			emit_signal("create_hwall", room.pos.x, room.pos.y-4)
			break
			
#		# BOTTOM
#		r = Rect2(Vector2(room.pos.x, room.pos.y+room.size-4), Vector2(room.size, 8))
#		if r.has_point(mouse_pos):
#			emit_signal("create_hwall", x, y)
#			break

func _draw():
	if not show_pointer:
		return
		
	if mode == mode_room:
		var x = floor(self.mouse_pos.x / size) * size
		var y = floor(self.mouse_pos.y / size) * size
		
		var r = Rect2(Vector2(x,y), Vector2(size, size))
		self.draw_rect(r, self.color, true, 1, false)
		
	if mode == mode_wall:
		ghost_wall()


func ghost_wall():
	
	var x = floor(self.mouse_pos.x / size) * size
	var y = floor(self.mouse_pos.y / size) * size	
	#var r = Rect2(Vector2(x,y), Vector2(size, size))
	#self.draw_rect(r, self.color, true, 1, false)
		
	# HACK - just grab the rooms and inspect them
	#        this needs to move somewhere
	var rooms = get_node("../Rooms").get_children()
	for room in rooms:
		
		if room.get_class() != "Square":
			continue
		
		# LEFT
		var r = Rect2(Vector2(room.pos.x-4, room.pos.y), Vector2(8, room.size))
		if r.has_point(mouse_pos):
			self.draw_rect(r, Color("#7FFFCC00"), true, 1, false)
			break
		
		# RIGHT
		r = Rect2(Vector2(room.pos.x+room.size-4, room.pos.y), Vector2(8, room.size))
		if r.has_point(mouse_pos):
			self.draw_rect(r, Color("#7FFFCC00"), true, 1, false)
			break
		
		# TOP
		r = Rect2(Vector2(room.pos.x, room.pos.y-4), Vector2(room.size, 8))
		if r.has_point(mouse_pos):
			self.draw_rect(r, Color("#7FFFCC00"), true, 1, false)
			break
			
		# BOTTOM
		r = Rect2(Vector2(room.pos.x, room.pos.y+room.size-4), Vector2(room.size, 8))
		if r.has_point(mouse_pos):
			self.draw_rect(r, Color("#7FFFCC00"), true, 1, false)
			break
	
	

func get_size():
	return self.size


func _on_btnWall_pressed():
	self.mode = mode_wall


func _on_btnRoom_pressed():
	self.mode = mode_room
