extends ProgressBar


func start(time):
	$Timer.start(time)
	value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if value < 100:
		value = 100 - $Timer.time_left / $Timer.wait_time * 100
