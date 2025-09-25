class_name Coin extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	body_entered.connect(on_collect)

func on_collect(_player: Player) -> void:
	PlayerManager.coins += 1
	animation_player.play("pickup")
