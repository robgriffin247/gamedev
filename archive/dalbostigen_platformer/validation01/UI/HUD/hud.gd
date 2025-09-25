extends CanvasLayer

@onready var coin_label: Label = $Coin/Label

func _ready() -> void:
	update_coin()

func _process(_delta: float) -> void:
	update_coin()


func update_coin() -> void:
	coin_label.text = " × " + str(PlayerManager.coins)
