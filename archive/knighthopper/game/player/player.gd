class_name Player extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var SPEED: float = 85.0
const JUMP_VELOCITY:float = -320.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if PlayerManager.alive and GameManager.reached_exit == false:
		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Handle left/right
		var direction := Input.get_axis("left", "right")
		
		if direction < 0:
			animated_sprite.flip_h = true
		elif direction > 0:
			animated_sprite.flip_h = false
		
		if is_on_floor():
			if direction==0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("walk")
		else:
			animated_sprite.play("jump")
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if PlayerManager.alive == false:
			animated_sprite.play("die")
		else:
			animated_sprite.play("idle")		
		
	move_and_slide()
	
	
