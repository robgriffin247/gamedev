extends CanvasLayer

@onready var retry_button: Button = $Control/RetryButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	retry_button.pressed.connect(_reload_level)


func _reload_level() -> void:
	get_tree().reload_current_scene()
	visible = false
	PlayerManager.reset_scores()
