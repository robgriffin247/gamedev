extends Node

const PLAYER = preload("res://game/player/player.tscn")

var player: Player
var player_spawned: bool = false

var coins: int = 0
var alive: bool = true
var slimes_killed: int = 0

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.1).timeout
	player_spawned = true
	
func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)


func set_player_position( _new_position: Vector2 ) -> void:
	if not player: # This fixed the double death bug!
		player = PLAYER.instantiate()
	player.global_position = _new_position


func set_as_parent( _parent: Node2D ) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_parent.add_child(player)


func unparent_player( _parent: Node2D) -> void:
	_parent.remove_child(player)
