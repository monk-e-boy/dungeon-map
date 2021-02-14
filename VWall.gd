extends Node2D

class_name VWall

var size = 1
var height = 8
var color = Color(0.8,0.8,0.8)
var line_color = Color(0.1,0.1,0.1)
var line_width = 1.0
var pos = Vector2(0,0)
var key = []
var rng = RandomNumberGenerator.new()
var jitter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var n = get_tree().get_root().get_node("Application")
	size = n.square_size_px()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_class():
	# override this as it returns "Node2D" - bug in godot
	return "VWall"

func _draw():
	self.rng.seed = self.pos.x * self.pos.y
	self.jitter = self.rng.randf()
	
	self.draw_rect(Rect2(pos, Vector2(8,size)), self.color, true)
	self.wall_left()
	self.wall_right()

func line(start, end):
	self.draw_line(pos+start, pos+end, line_color, line_width, true)

func set_pos(v):
	self.pos = v
	self.key = [floor(v.x/self.size), floor(v.y/self.size)]

func jitter():
	# approx 5%
	var offset = self.size * 0.05
	return self.rng.randf_range(-offset, offset)

func wall_left():
	if self.jitter > 0.5:
		# two lines
		var x1 = self.jitter()
		self.line(Vector2(x1,0), Vector2(-x1,self.size))
	else:
		# three lines
		var x1 = self.jitter()
		var x2 = self.jitter()
		self.line(Vector2(x1,0), Vector2(-x1,self.size/2))
		self.line(Vector2(-x1,self.size/2), Vector2(x2,self.size))
		
func wall_right():
	if self.jitter > 0.5:
		# two lines
		var x1 = self.jitter()
		self.line(Vector2(self.height+x1,0), Vector2(self.height-x1, self.size))
	else:
		# three lines
		var x1 = self.jitter()
		var x2 = self.jitter()
		self.line(Vector2(self.height+x1,0), Vector2(self.height-x1,self.size/2))
		self.line(Vector2(self.height-x1,self.size/2), Vector2(self.height+x2,self.size))
