extends Control

@onready var coins_label: Label = $Panel/Scores/Coins/Label
@onready var slimes_label: Label = $Panel/Scores/Slimes/Label
@onready var restart_button: Button = $Panel/Buttons/RestartButton
@onready var title_label: Label = $Panel/TitleRow/Label
@onready var panel: Panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if GameManager.reached_exit:
		title_label.text = "CONGRATULATIONS!"
		restart_button.text = " RESTART "
		pass
	elif PlayerManager.alive == false:
		title_label.text = "GAME OVER!"
		restart_button.text = " RETRY "
		pass
		
	if PlayerManager.alive == false or GameManager.reached_exit == true:
		coins_label.text = "× " + str(PlayerManager.coins)
		slimes_label.text = "× " + str(PlayerManager.slimes_killed)
		await get_tree().create_timer(0.85).timeout
		self.visible = true
		


func _on_restart_button_pressed() -> void:
	PlayerManager.alive = true
	GameManager.reached_exit = false
	PlayerManager.coins = 0
	PlayerManager.slimes_killed = 0
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
