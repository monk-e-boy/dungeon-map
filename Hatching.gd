extends Node2D

var points = PoolVector2Array()
var triangles = []
var traingles_draw_list = []
var debug = true
var rng = RandomNumberGenerator.new()
var thread

func _ready():
	self.rng.seed = 17
	#self.jitter = self.rng.randf()
	
	# hatching takes time:
#	thread = Thread.new()
#	thread.start(self, "_thread_function")
	_thread_function()


func _thread_function():
	halton_points()
	create_triangles()
	self.update()


func _exit_tree():
	#thread.wait_to_finish()
	pass


func create_triangles():
	# triangulation
	var t = Geometry.triangulate_delaunay_2d(points)
	var length = len(t)
	var count = length / 3
	var pos = 0
	for c in range(count):
		var tri = [points[t[pos+0]], points[t[pos+1]], points[t[pos+2]]]
		triangles.append(tri)
		pos += 3


func regular_points():
	for x in range(10):
		for y in range(10):
			points.append(Vector2(20+(30*x), 20+(30*y)))


func halton_points():
	# https://gist.github.com/bpeck/1889735
	var width = 1098
	var height = 777
	for i in range(700):
		var a = halton(i, 2)
		var b = halton(i, 3)
		# -20 and 20 - we want the triangles to go off the sides
		# to make the hatching look nice
		
		points.append(Vector2(-5+((width+10)*a), -5+((height+10)*b)))


# they appear to be randomish but cover the domain uniformly
func halton(index : int, base : int):
	var result = 0.0
	var f = 1.0 / base
	var i = index
	while i > 0:
		result = result + f * (i % base)
		i = int(floor(i / base))
		f = f / base
		
	return result


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hatch_triangle(p1,p2,p3):
	# TODO - choose shortest side, short hatches look better
	var tmp = Vector2(1,1)
	
	# how much the lines wander up and down
	# the left and right vectors:
	#       /\
	#      /  \
	#     /    \
	#    +------+   <--- this is the line / hatch we are
	#   /        \       calculating
	#  /          \
	# v1          v2
	#
	var side1 = p2 - p1
	var side2 = p3 - p1
	
	var num_lines = 4
	var step = 1.0/(num_lines)
	var bump = step
	for i in range(num_lines):
		var point1 = (side1 * bump) + p1
		var point2 = (side2 * bump) + p1
		
		draw_line(point1, point2, Color(0,0,0), 1, true)
		
		bump += step




func hatch_this(p1:Vector2, p2:Vector2):
	for tri in triangles:
		if Geometry.segment_intersects_segment_2d(p1,p2,tri[0],tri[1]):
			traingles_draw_list.append([tri[0], tri[1], tri[2]])
		elif Geometry.segment_intersects_segment_2d(p1,p2,tri[1],tri[2]):
			traingles_draw_list.append([tri[0], tri[1], tri[2]])
		elif Geometry.segment_intersects_segment_2d(p1,p2,tri[2],tri[0]):
			traingles_draw_list.append([tri[0], tri[1], tri[2]])
	
	self.update()


func _draw():
	for t in triangles:
		if debug:
			draw_line(t[0], t[1], Color(0.9,0.7,0.7), 1, true)
			draw_line(t[1], t[2], Color(0.9,0.7,0.7), 1, true)
			draw_line(t[2], t[0], Color(0.9,0.7,0.7), 1, true)
	
	for t in traingles_draw_list:
		hatch_triangle(t[0], t[1], t[2])
	
	if debug:
		for p in points:
			draw_circle(p, 2, Color(1,0,0))
		
