extends RichTextLabel
func _process(_delta: float) -> void:
	var nbsp = "\u00A0"
	var line = ""
	
	line += "[img=25]res://assets/rockk.png[/img]%s%s    " % [nbsp, Global.f_n(Global.rock)]
	line += "[img=25]res://assets/copperparts/copperingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.copper)]
	line += "[img=25]res://assets/ironparts/ironingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.iron)]
	line += "[img=25]res://assets/goldparts/goldingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.gold)]
	line += "[img=25]res://assets/zincparts/zincingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.zinc)]
	line += "[img=25]res://assets/emeraldparts/emeraldd.png[/img]%s%s    " % [nbsp, Global.f_n(Global.emerald)]
	line += "[img=25]res://assets/lapisparts/lapislazuli.png[/img]%s%s    " % [nbsp, Global.f_n(Global.lapis)]
	line += "[img=25]res://assets/diamondparts/diamondd.png[/img]%s%s    " % [nbsp, Global.f_n(Global.diamond)]
	line += "[img=25]res://assets/titaniumparts/titaniumingot.png[/img]%s%s    " % [nbsp, Global.f_n(Global.titanium)]
	line += "\nMult: "    + str(Global.f_n(Global.rock1mult))
	
	text = line
