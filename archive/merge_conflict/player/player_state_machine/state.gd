class_name PlayerState extends Node

# Ref to player so states can manipulate player
static var player: Player


func _ready() -> void:
	pass


# What happens when the player enters the state
func enter() -> void:
	pass


# What happens when the player exits the state
func exit() -> void:
	pass


# What happens on tick; returning a PlayerState if the PlayerState changes
func process( _delta: float) -> PlayerState:
	return null


func physics( _delta: float) -> PlayerState:
	return null


# What happens with input events while in the PlayerState
func handle_input(_event: InputEvent) -> PlayerState:
	return null
