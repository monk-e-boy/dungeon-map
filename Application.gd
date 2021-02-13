extends Node2D


var settings_file = "user://dungeon_mapper.settings.save"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	OS.set_window_maximized(true)
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_settings()
		get_tree().quit()

func get_scale():
	return 3.7

func square_size_px():
	# 28mm approx 1 inch - standard D&D sizes
	# snap to whole pixels
	return int(floor(28 * self.get_scale()))

var last_path = ""

func _on_btnSavePng_pressed():
	if len(last_path):
		$FileDialog.set_current_dir(last_path)
	$FileDialog.popup_centered()
	
func _on_FileDialog_file_selected(path):
	$FileDialog.hide()
	get_tree().root.get_viewport()
	var img = get_tree().root.get_viewport().get_texture().get_data()
	img.flip_y()
	img.save_png(path)
	
	last_path = path


func save_settings():
	var f = File.new()
	f.open(settings_file, File.WRITE)
	f.store_var(last_path)
	f.store_var($FileDialog.rect_global_position)
	f.store_var($Menu1.rect_global_position)
	f.close()

func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file, File.READ)
		last_path = f.get_var()
		$FileDialog.rect_global_position = f.get_var()
		$Menu1.rect_global_position = f.get_var()
		f.close()

