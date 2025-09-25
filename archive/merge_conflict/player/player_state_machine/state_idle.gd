class_name PlayerStateIdle extends PlayerState

@onready var walk: PlayerStateWalk = $"../Walk"

func enter() -> void:
	player.update_animation("idle")


func exit() -> void:
	pass


func process( _delta: float) -> PlayerState:
	if player.direction != Vector2.ZERO:
		return walk
		
	player.velocity = Vector2.ZERO
	return null


func physics( _delta: float) -> PlayerState:
	return null


func handle_input(_event: InputEvent) -> PlayerState:
	return null
