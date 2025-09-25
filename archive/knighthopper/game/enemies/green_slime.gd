class_name Slime extends Node2D

var SPEED: int = 30
var DIRECTION: int = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Killzone = $Killzone

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if ray_cast_right.is_colliding():
		DIRECTION = -1
		animated_sprite.flip_h = true
		
	if ray_cast_left.is_colliding():
		DIRECTION = 1
		animated_sprite.flip_h = false
		
	position.x += DIRECTION * SPEED * delta
