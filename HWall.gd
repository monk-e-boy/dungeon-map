extends Node2D

class_name HWall

var size = 1
var height = 8
var color = Color(1,1,0)
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


func _draw():
	self.rng.seed = self.pos.x * self.pos.y
	self.jitter = self.rng.randf()
	
	self.draw_rect(Rect2(pos, Vector2(size,8)), self.color, true)
	self.wall_top()
	self.wall_bottom()

func line(start, end):
	# HDR (project settings MUST BE OFF for anti-aliasing to work)
	# MSAA set to highest value for sexy smoothness
	self.draw_line(pos+start, pos+end, line_color, line_width, true)

func set_pos(v):
	self.pos = v
	# HACK - generate a key so we can figure out who's next to us
	self.key = [floor(v.x/self.size), floor(v.y/self.size)]

func jitter():
	# approx 5%
	var offset = self.size * 0.05
	return self.rng.randf_range(-offset, offset)

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
		self.line(Vector2(0, self.height+y1), Vector2(self.size, self.height-y1))
	else:
		# three lines
		var y1 = self.jitter()
		var y2 = self.jitter()
		self.line(Vector2(0, self.height+y1), Vector2(self.size/2, self.height-y1))
		self.line(Vector2(self.size/2, self.height-y1), Vector2(self.size, self.height+y2))
