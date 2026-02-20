extends RichTextLabel
func _process(_delta: float) -> void:
	var nbsp = "\u00A0"
	var line = ""
	
	line += "[img=40]res://assets/rockk.png[/img]%s%s    " % [nbsp, Global.f_n(Global.rock)]
	line += "\n[img=40]res://assets/copperparts/copperingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.copper)]
	line += "\n[img=40]res://assets/ironparts/ironingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.iron)]
	line += "\n[img=40]res://assets/goldparts/goldingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.gold)]
	line += "\n[img=40]res://assets/zincparts/zincingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.zinc)]
	line += "\n[img=40]res://assets/emeraldparts/emeraldd.png[/img]%s%s    " % [nbsp, Global.f_n(Global.emerald)]
	line += "\n[img=40]res://assets/lapisparts/lapislazuli.png[/img]%s%s    " % [nbsp, Global.f_n(Global.lapis)]
	line += "\n[img=40]res://assets/diamondparts/diamondd.png[/img]%s%s" % [nbsp, Global.f_n(Global.diamond)]
	line += "\nMult: "    + str(Global.f_n(Global.rock1mult))
	
	text = line
