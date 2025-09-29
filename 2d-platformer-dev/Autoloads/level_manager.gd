extends Node

var current_bounds : Array[Vector2]

signal bounds_changed(bounds: Array[Vector2])

func update_level_bounds(bounds: Array[Vector2]) -> void:
	current_bounds = bounds
	bounds_changed.emit(current_bounds)
