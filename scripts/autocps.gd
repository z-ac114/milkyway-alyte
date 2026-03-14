extends Label

func _process(delta):
	if Global.current_interval > 0:
		text = "Auto CPS: " + (Global.f_n(1/(Global.current_interval)))
	else:
		text = "Auto CPS: 0"
