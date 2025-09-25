class_name PlayerCamera extends Camera2D


func _ready() -> void:
	LevelManager.level_bounds_changed.connect(_update_limits)
	_update_limits(LevelManager.current_level_bounds)


func _update_limits(bounds: Array[Vector2]) -> void:
	if bounds == []:
		return
		
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
