extends Label


func _process(delta):
	text = "FPS: %d\nNodos: %d" % [
		Engine.get_frames_per_second(),
		get_tree().get_node_count()
	]
