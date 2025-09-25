class_name Slime extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var sprite: Sprite2D = $Sprite2D

var speed := 40
var direction := 1

func _physics_process(delta: float) -> void:
	
	if ray_cast_right.is_colliding():
		direction = -1 
	if ray_cast_left.is_colliding():
		direction = 1 
	sprite.scale.x = direction
	position.x += delta * direction * speed
	
