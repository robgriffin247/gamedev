class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $HitBox

const SPEED = 80.0
const JUMP_VELOCITY = -310.0


func _ready() -> void:
	PlayerManager.hp = PlayerManager.max_hp
	hit_box.hit.connect(_take_hit)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = 0.0 if PlayerManager.hp <= 0 else Input.get_axis("left", "right")

	if PlayerManager.hp >0:
		if direction > 0:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
		
	sprite.scale.x = direction if direction != 0 else sprite.scale.x
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _take_hit(_damage: int) -> void:
	PlayerManager.hp -= _damage
	if PlayerManager.hp<=0:
		animation_player.play("die")
		GameOver.animation_player.play("show")
