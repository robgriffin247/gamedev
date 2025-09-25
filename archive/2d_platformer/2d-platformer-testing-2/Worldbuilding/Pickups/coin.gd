class_name Coin extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	body_entered.connect(_pickup)

func _pickup(_player: Player) -> void:
	PlayerManager.player.coins += 1
	animation_player.play("pickup")
