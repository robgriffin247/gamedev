class_name Coin extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	body_entered.connect(_picked_up)

func _picked_up(_p: Player) -> void:
	animation_player.play("pickup")
	PlayerManager.pickup_coin()
