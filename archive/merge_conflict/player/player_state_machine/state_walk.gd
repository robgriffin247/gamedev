class_name PlayerStateWalk extends PlayerState

var move_speed: float = 140.

@onready var idle: PlayerStateIdle = $"../Idle"

func enter() -> void:
	player.update_animation("walk")


func exit() -> void:
	pass


func process( _delta: float) -> PlayerState:
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity = player.direction * move_speed
	
	# If player direction changes while in state
	if player.set_direction():
		player.update_animation("walk")
	
	return null


func physics( _delta: float) -> PlayerState:
	return null


func handle_input(_event: InputEvent) -> PlayerState:
	return null
