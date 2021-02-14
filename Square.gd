extends Node2D

class_name Square

var color = Color(0.95,0.95,0.95)
var highlight = false
var pos = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var jitter = 0
var size = 1
var line_color = Color(0.1,0.1,0.1)
var line_width = 1.0
var dot_color = Color(0.1,0.1,0.1)

var key = []

# walls?
var top = true setget top_set, top_get
var bottom = true setget bottom_set, bottom_get
var left = true setget left_set, left_get
var right = true setget right_set, right_get

# Called when the node enters the scene tree for the first time.
func _ready():
	#var grid = get_tree().get_root().get_node("Application/Grid")
	var n = get_tree().get_root().get_node("Application")
	size = n.square_size_px()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_class():
	# override this as it returns "Node2D" - bug in godot
	return "Square"

func set_pos(v):
	self.pos = v
	# HACK - generate a key so we can figure out who's next to us
	self.key = [floor(v.x/self.size), floor(v.y/self.size)]
	
func enable_walls(top, right, bottom, left):
	self.top = top
	self.bottom = bottom
	self.left = left
	self.right = right
	self.update()

func _draw():
	self.draw_rect(Rect2(pos, Vector2(size,size)), self.color, true)

	if self.highlight:
		self.draw_rect(Rect2(pos, Vector2(size,size)), Color(1,1,0), false)
	
	
	var label = Label.new()
	var font = label.get_font("")
	label.queue_free()
	draw_string(font, self.pos+Vector2(3, 13), str(self.key), Color(0,0,0))
	#
	# reset the RNG
	#
	self.rng.seed = self.pos.x * self.pos.y
	self.jitter = self.rng.randf()
	
	self.wall_top()		if top else		self.dots_top()
	self.wall_bottom()	if bottom else	self.dots_bottom()
	self.wall_left()	if left else	self.dots_left()
	self.wall_right()	if right else	self.dots_right()

func left_set(val):
	left = val
	self.update()

func left_get():
	return left
	
func right_set(val):
	right = val
	self.update()

func right_get():
	return right
	
func top_set(val):
	top = val
	self.update()

func top_get():
	return top
	
func bottom_set(val):
	bottom = val
	self.update()

func bottom_get():
	return bottom

func jitter():
	# approx 5%
	var offset = self.size * 0.05
	return self.rng.randf_range(-offset, offset)
	#return self.rng.randf_range(-1.5, 1.5)

func line(start, end):
	# HDR (project settings MUST BE OFF for anti-aliasing to work)
	# MSAA set to highest value for sexy smoothness
	self.draw_line(pos+start, pos+end, line_color, line_width, true)

func dot(pos):
	self.draw_line(self.pos+pos, self.pos+pos+Vector2(1,0), dot_color, line_width, true)

func dots_top():
	# number of dots between 0 and 7
	# sprinkle them randomly along the line
	var num_dots = self.rng.randi_range(0,7)
	for i in range(num_dots):
		self.dot(Vector2(self.size * self.rng.randf(), 0))
		
func dots_bottom():
	var num_dots = self.rng.randi_range(0,7)
	for i in range(num_dots):
		self.dot(Vector2(self.size * self.rng.randf(), self.size))

func dots_left():
	var num_dots = self.rng.randi_range(0,7)
	for i in range(num_dots):
		self.dot(Vector2(0, self.size * self.rng.randf()))

func dots_right():
	var num_dots = self.rng.randi_range(0,7)
	for i in range(num_dots):
		self.dot(Vector2(self.size, self.size * self.rng.randf()))

func wall_top():
	if self.jitter > 0.5:
		# two lines
		var y1 = self.jitter()
		self.line(Vector2(0,y1), Vector2(self.size, -y1))
	else:
		# three lines
		var y1 = self.jitter()
		var y2 = self.jitter()
		self.line(Vector2(0, y1), Vector2(self.size/2, -y1))
		self.line(Vector2(self.size/2, -y1), Vector2(self.size, y2))
		
func wall_bottom():
	if self.jitter > 0.5:
		# two lines
		var y1 = self.jitter()
		self.line(Vector2(0, self.size+y1), Vector2(self.size, self.size-y1))
	else:
		# three lines
		var y1 = self.jitter()
		var y2 = self.jitter()
		self.line(Vector2(0, self.size+y1), Vector2(self.size/2, self.size-y1))
		self.line(Vector2(self.size/2, self.size-y1), Vector2(self.size, self.size+y2))

func wall_left():
	if self.jitter > 0.5:
		# two lines
		var x1 = self.jitter()
		self.line(Vector2(x1, 0), Vector2(-x1, self.size))
	else:
		# three lines
		var x1 = self.jitter()
		var x2 = self.jitter()
		self.line(Vector2(-x1, 0), Vector2(x1, self.size/2))
		self.line(Vector2(x1, self.size/2), Vector2(-x2, self.size))

func wall_right():
	if self.jitter > 0.5:
		# two lines
		var x1 = self.jitter()
		self.line(Vector2(self.size+x1, 0), Vector2(self.size-x1, self.size))
	else:
		# three lines
		var x1 = self.jitter()
		var x2 = self.jitter()
		self.line(Vector2(self.size-x1, 0), Vector2(self.size+x1, self.size/2))
		self.line(Vector2(self.size+x1, self.size/2), Vector2(self.size-x2, self.size))
