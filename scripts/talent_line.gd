extends Line2D
class_name TalentLine

var dependent_talent_id: String

func _ready() -> void:
	z_index = 100
	z_as_relative = false
