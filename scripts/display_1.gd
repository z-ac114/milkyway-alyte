extends RichTextLabel

func _process(_delta: float) -> void:
	var nbsp = "\u00A0"
	var line = ""
	
	line += "[img=20]res://assets/rockk.png[/img]%s%s    " % [nbsp, Global.f_n(Global.rock)]
	line += "[img=20]res://assets/copperparts/copperingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.copper)]
	line += "[img=20]res://assets/ironparts/ironingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.iron)]
	line += "[img=20]res://assets/goldparts/goldingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.gold)]
	line += "[img=20]res://assets/zincparts/zincingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.zinc)]
	line += "[img=20]res://assets/emeraldparts/emeraldd.png[/img]%s%s    " % [nbsp, Global.f_n(Global.emerald)]
	line += "[img=20]res://assets/lapisparts/lapislazuli.png[/img]%s%s    " % [nbsp, Global.f_n(Global.lapis)]
	line += "[img=20]res://assets/diamondparts/diamondd.png[/img]%s%s" % [nbsp, Global.f_n(Global.diamond)]
	
	text = line
