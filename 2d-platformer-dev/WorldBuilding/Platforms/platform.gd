@tool
class_name Platform extends AnimatableBody2D

enum WIDTH {narrow, wide}
enum STYLE {grass, sand, lava, ice}

@export var width := WIDTH.wide:
	set(_width):
		width = _width
		_update_width()
		
@export var style := STYLE.grass:
	set(_style):
		style = _style
		_update_style()
		
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_update_width()
	_update_style()


func _update_width() -> void:
	var width_in_px := 16 if width == WIDTH.narrow else 32
	
	if sprite:
		sprite.region_rect.size.x = width_in_px
		sprite.region_rect.position.x = width_in_px-16	
	if collision_shape:
		collision_shape.shape.size.x = width_in_px


func _update_style() -> void:
	if sprite:
		sprite.region_rect.position.y = style*16
