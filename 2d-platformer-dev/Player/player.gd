class_name Player extends CharacterBody2D

var speed = 95.0
const JUMP_VELOCITY = -305.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $HitBox

var max_hp := 1
var hp : int

func _ready() -> void:
	hit_box.hit.connect(_take_hit)
	hp = max_hp

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and hp>0:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction and hp>0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	sprite.scale.x = sign(direction) if direction!=0 and hp>0 else sprite.scale.x
	
	animation_player.play("walk" if velocity.x!=0 else "idle")
	
	move_and_slide()

func _take_hit(_damage: int) -> void:
	hp -= _damage
	if hp <= 0:
		await get_tree().create_timer(0.5).timeout
		await get_tree().physics_frame
		get_tree().reload_current_scene()
