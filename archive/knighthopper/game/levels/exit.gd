extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	PlayerManager.player_spawned = false
	GameManager.reached_exit = true
	print('exit')
