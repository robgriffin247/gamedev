extends Node

signal score_change

var max_hp := 1
var hp : int
var coins := 0


func add_coin() -> void:
	coins += 1
	score_change.emit()

func reset_scores() -> void:
	coins = 0
	score_change.emit()
