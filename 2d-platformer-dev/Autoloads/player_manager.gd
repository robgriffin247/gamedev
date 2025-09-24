extends Node

signal coins_changed

var coins : int

func _ready() -> void:
	coins = 0

func pickup_coin() -> void:
	coins += 1
	coins_changed.emit()
