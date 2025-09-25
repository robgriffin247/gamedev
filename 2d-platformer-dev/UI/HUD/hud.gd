extends CanvasLayer

@onready var coin_count: Label = $Label

func _ready() -> void:
	_update_coin_count()
	PlayerManager.coins_changed.connect(_update_coin_count)
	
func _update_coin_count() -> void:
	coin_count.text = "x " + str(PlayerManager.coins)
