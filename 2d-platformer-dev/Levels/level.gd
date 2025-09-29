class_name Level extends Node2D

@onready var tile_sets: Node2D = $TileSets


func _ready() -> void:
	LevelManager.update_level_bounds(get_bounds())

func get_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	var left:int
	var right:int
	var top:int
	var bottom:int

	for t in tile_sets.get_children():
		if is_instance_of(t, TileMapLayer):
			left = min(left, (t.get_used_rect().position * t.rendering_quadrant_size)[0])
			right = max(right, (t.get_used_rect().end * t.rendering_quadrant_size)[0])
			top = min(top, (t.get_used_rect().position * t.rendering_quadrant_size)[1])
			bottom = max(bottom, (t.get_used_rect().end * t.rendering_quadrant_size)[1])
	
	bounds.append(Vector2(left, top))
	bounds.append(Vector2(right, bottom))
	
	return bounds
