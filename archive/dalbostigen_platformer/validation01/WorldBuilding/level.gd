class_name Level extends Node2D

@onready var tile_sets: Node2D = $TileSets

func _ready() -> void:
	LevelManager.change_level_bounds(get_tilemap_bounds())


func get_tilemap_bounds() -> Array[Vector2]:
	
	var bounds : Array[Vector2] = []
	
	var left_limit : int
	var top_limit : int
	var right_limit : int
	var bottom_limit : int
	
	for c in tile_sets.get_children():
		left_limit = min(left_limit, (c.get_used_rect().position * c.rendering_quadrant_size)[0])
		top_limit = min(top_limit, (c.get_used_rect().position * c.rendering_quadrant_size)[1])
		right_limit = max(right_limit, (c.get_used_rect().end * c.rendering_quadrant_size)[0])
		bottom_limit = max(bottom_limit, (c.get_used_rect().end * c.rendering_quadrant_size)[1])
	
	bounds.append(
		Vector2(left_limit, top_limit)
	)
	
	bounds.append(
		Vector2(right_limit, bottom_limit)
	)
	
	print(bounds)

	return bounds
