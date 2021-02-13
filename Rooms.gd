#
# Draws the rooms
#
extends Node2D


var rooms = []
var room_highlight = Vector2(-1,-1)

# Move into room?
var squares = []

onready var square = $Square

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseMotion:
		room_highlight = Vector2(-1,-1)
		for room in self.rooms:
			var r = Rect2(room, Vector2(32,32))
			if r.encloses(Rect2(event.position, Vector2(1,1))):
				room_highlight = room
		self.update()
		
		
	if event is InputEventMouseButton:
		pass


func _draw():
	pass


func _on_Grid_create_room(x, y):
	if not square:
		return
	
	var found = false
	
	for s in self.get_children():
		if s.pos == Vector2(x, y):
			remove_child(s)
			found = true
			var l_key = s.key.duplicate()
			l_key[0] -= 1
			
			var r_key = s.key.duplicate()
			r_key[0] += 1
			
			var t_key = s.key.duplicate()
			t_key[1] -= 1
			
			var b_key = s.key.duplicate()
			b_key[1] += 1
			
			for c in self.get_children():
				if c.key == l_key:
					c.right = true
				if c.key == r_key:
					c.left = true
				if c.key == t_key:
					c.bottom = true
				if c.key == b_key:
					c.top = true
			
	if not found:
		var s = Square.new()
		add_child(s)
		s.set_pos(Vector2(x, y))

		var l_key = s.key.duplicate()
		l_key[0] -= 1
		
		var r_key = s.key.duplicate()
		r_key[0] += 1
		
		var t_key = s.key.duplicate()
		t_key[1] -= 1
		
		var b_key = s.key.duplicate()
		b_key[1] += 1
		
		for c in self.get_children():
			if c.key == l_key:
				s.left = false
				c.right = false
			if c.key == r_key:
				s.right = false
				c.left = false
			if c.key == t_key:
				s.top = false
				c.bottom = false
			if c.key == b_key:
				s.bottom = false
				c.top = false



func _on_Grid_create_hwall(x, y):
	var s = HWall.new()
	add_child(s)
	s.set_pos(Vector2(x, y))


func _on_Grid_create_vwall(x, y):
	var s = HWall.new()
	add_child(s)
	s.set_pos(Vector2(x, y))
