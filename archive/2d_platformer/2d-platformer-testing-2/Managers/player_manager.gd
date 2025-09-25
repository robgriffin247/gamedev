extends Node

const PLAYER = preload("res://Player/player.tscn")

var player : Player

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.1).timeout
	player.is_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)

func set_player_position(position: Vector2) -> void:
	player.global_position = position
	player.is_spawned = true

func set_as_parent(_parent: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_parent.add_child(player)

func unparent_player(_parent: Node2D) -> void:
	_parent.remove_child(player)
