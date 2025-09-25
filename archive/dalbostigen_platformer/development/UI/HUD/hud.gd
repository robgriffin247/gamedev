extends CanvasLayer

@onready var coin_count: Label = $Coins/Label

func _ready() -> void:
	PlayerManager.score_change.connect(_update_coins)
	_update_coins()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_coins()
	

func _update_coins() -> void:
	coin_count.text = "×" + str(PlayerManager.coins)
