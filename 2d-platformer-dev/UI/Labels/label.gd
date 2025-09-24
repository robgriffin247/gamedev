@tool
class_name LabelRegular extends Label

@export var font_size := 1 :
	set(_fs):
		font_size = _fs
		_update_font_size()

func _ready() -> void:
	_update_font_size()

func _update_font_size() -> void:
	add_theme_font_size_override("font_size", font_size * 8)
