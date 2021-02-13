extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _scale = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	self.update()
	var n = get_tree().get_root().get_node("Application")
	self._scale = n.get_scale()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _draw():
	var width = 297 * self._scale
	var height = 210 * self._scale
	
	var size = Rect2(Vector2(5,5), Vector2(width, height))
	#size = size.grow(2.0)
	self.draw_rect(size, Color(0.8,0.8,0.8), true, 1, false)

