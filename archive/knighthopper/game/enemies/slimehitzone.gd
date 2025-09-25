extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	
	if PlayerManager.alive:
		get_parent().animated_sprite.play("death")
		get_parent().killzone.queue_free()
		get_parent().SPEED = 0.0
		await get_tree().create_timer(0.8).timeout
		get_parent().queue_free()
		PlayerManager.slimes_killed += 1
