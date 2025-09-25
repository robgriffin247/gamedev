extends CanvasLayer

@onready var coins_count: Label = $Control/CoinsCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	coins_count.text = "× " + str(PlayerManager.player.coins)
