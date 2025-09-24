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
1. Project settings > Display/Window/Stretch/Mode: Viewport



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



1. New 2D scene; ``Area2D`` node called ``Coin``
1. Add ``Coin/Sprite2D`` and sprite sheet; adjust animation
1. Add ``Coin/CollisionShape2D`` and shape to suit
1. Add ``Coin/AnimationPlayer`` and add *default* animation
1. Add a script 
    ```
    class_name Coin extends Area2D

    func _ready() -> void:
        body_entered.connect(_picked_up)

    func _picked_up(_p: Player) -> void:
        print("+1")
    ```
1. Add ``Level/Pickups/`` then instantiate a few coins into the level and test the game

1. Add a PlayerManager script to autoloads
    ```
    extends Node

    var coins : int
    ```
1. Add coins when area entered and test
    ```
    class_name Coin extends Area2D

    func _ready() -> void:
        body_entered.connect(_picked_up)

    func _picked_up(_p: Player) -> void:
        PlayerManager.coins += 1
        print(str(PlayerManager.coins))
    ```

1. Add a pickup animation; important to queue_free() collision shape on 0 and queue_free() whole coin at end
1. Add animation play to area entered behaviour and test
    ```
    class_name Coin extends Area2D

    @onready var animation_player: AnimationPlayer = $AnimationPlayer

    func _ready() -> void:
        body_entered.connect(_picked_up)

    func _picked_up(_p: Player) -> void:
        animation_player.play("pickup")
        PlayerManager.coins += 1
        print(str(PlayerManager.coins))
    ```

1. Add a new 2d scene with ``CanvasLayer`` root called ``HUD``
1. Add a ``Label`` and a ``Sprite2D``
1. Add the coin to the sprite
1. Save label as a scene and open it;
    - Add font to theme overrides
    - Add script to label scene to allow font size to be multiples of 8 only
        ```
        @tool
        class_name LabelRegular extends Label

        @export var font_size := 1 :
            set(_fs):
                font_size = _fs
                _update_font_size()

        func _ready() -> void:
            _update_font_size()

        func _update_font_size() -> void:
            add_theme_font_size_override("font_size", font_size * 8)

        ```
1. Position the sprite and label (add x000 as the label text to help!); set scale on sprite and font-size on label
1. Modify the player manager
    ```
    extends Node

    signal coins_changed

    var coins : int

    func _ready() -> void:
        coins = 0

    func pickup_coin() -> void:
        coins += 1
        coins_changed.emit()
    ```
1. Change code in coin script from
    ```
	PlayerManager.coins += 1
    ```
    to
    ```
    PlayerManager.pickup_coin()
    ```
1. Add a script to ``HUD``
    ```
    extends CanvasLayer

    @onready var coin_count: Label = $Label

    func _ready() -> void:
        _update_coin_count()
        PlayerManager.coins_changed.connect(_update_coin_count)
        
    func _update_coin_count() -> void:
        coin_count.text = "x" + str(PlayerManager.coins)
    ```