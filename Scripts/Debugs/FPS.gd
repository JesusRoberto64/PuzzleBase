extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "FPS: " + str(Engine.get_frames_per_second())
	#Engine.get_frames_per_second()
	pass
