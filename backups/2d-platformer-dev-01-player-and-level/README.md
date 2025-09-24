1. New 2D scene with root of ``CharacterBody`` called ``Player``
1. Add ``Player/Sprite2D``
1. Add spritesheet to texture
1. Set animation hframes and vframes
1. In project settings, set rendering/textures/canvas textures/default texture filter to nearest
1. Position the sprite
1. Add ``Player/AnimationPlayer`` node
1. Add *idle* and *walk* animations (length, snap, loop and autoplay, then key sprite frames)
1. Add ``Player/CollisionShape2D`` and a suitable shape
1. Add a script to ``Player`` node, using basic movement template

    ````
    class_name Player extends CharacterBody2D

    var speed = 100.0
    const JUMP_VELOCITY = -305.0

    @onready var sprite: Sprite2D = $Sprite2D
    @onready var animation_player: AnimationPlayer = $AnimationPlayer

    func _physics_process(delta: float) -> void:
        # Add the gravity.
        if not is_on_floor():
            velocity += get_gravity() * delta

        # Handle jump.
        if Input.is_action_just_pressed("jump") and is_on_floor():
            velocity.y = JUMP_VELOCITY

        # Get the input direction and handle the movement/deceleration.
        var direction := Input.get_axis("left", "right")
        if direction:
            velocity.x = direction * speed
        else:
            velocity.x = move_toward(velocity.x, 0, speed)

        sprite.scale.x = sign(direction) if direction!=0 else sprite.scale.x
        
        animation_player.play("walk" if velocity.x!=0 else "idle")
        
        move_and_slide()
    ````

1. Add ``Player/Camera2D`` with zoom set to 4, and position over player

1. New 2D scene with ``TileMapLayer`` root node, called ``WorldTileSet``
1. Add tileset
1. Select tiles
1. Add a physics layer to the tileset
1. Paint solid tiles

1. Create new 2D scene with ``Node2D`` root called ``Level``
1. Add another ``Node2D`` as ``Level/TileSets``
1. Add three ``WorldTileSet``  scenes to ``Level/TileSets`` called ``Back``, ``Mid`` and ``Fore``
1. Set the z-index of ``Fore`` to 1000
1. Paint some tiles on each layer

1. Create a 2d scene with ``Node2D`` root called ``Playground``
1. Drag in the level and player scenes
1. Run the game (set current to main)
