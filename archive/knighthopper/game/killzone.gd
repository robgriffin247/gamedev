class_name Killzone extends Area2D

	
func _on_body_entered(body: Node2D) -> void:
	PlayerManager.alive = false
	body.get_node("AnimationPlayer").play("death_sound")
	PlayerManager.player_spawned = false
	self.set_collision_mask_value(2, false)
	
	Engine.time_scale = 1.0
	await get_tree().create_timer(0.8).timeout
