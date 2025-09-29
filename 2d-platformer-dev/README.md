# Player

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

# WorldBuilding

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


# Pickups: Coin

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

# HUD

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
1. Position the sprite and label (add x 000 as the label text to help!); set scale on sprite and font-size on label
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
        coin_count.text = "x " + str(PlayerManager.coins)
    ```
1. Add HUD **scene** as an autoload


# Dying

1. Add a HitBox:
    - Area2D, collision layer to enemy (9), collision mask -> none, monitoring: false; with script:
    ```
    class_name HitBox extends Area2D

    signal hit(damage: int)

    func _take_hit(_damage: int) -> void:
        hit.emit(_damage)
    ```
1. Add a HurtBox:
    - Area2D, collision layer to null, collision mask -> 2 (playerhurt), monitorable: false; with script:
    ```
    class_name HurtBox extends Area2D

    @export var damage_effect : int = 1

    func _ready() -> void:
        area_entered.connect(_area_entered)

    func _area_entered( _area: Area2D) -> void:
        if _area is HitBox:
            _area._take_hit(damage_effect)
    ```
1. Add a hitbox to player, setting layer to 2 (playerhurt)
1. Add a collisionshape to hitbox
1. Update player script to add onready to hitbox, hp and max_hp vars, ready() to set hp and 	hit_box.hit.connect(_take_hit), and a _take_hit() to cost damage from hp and reset if player dies
    ```
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
            await get_tree().physics_frame
            get_tree().reload_current_scene()

    ```
1. Add hurtbox to the level with appropriate position and shape

# Enemies 

1. New 2D scene with root node of Node2D called Slime
1. Add Slime/Sprite2D and sprites
1. Add Slime/Area2D and Slime/Area2D/CollisionShape2D (area2d as a child rather than root used becuase we will later add area2ds that act on other layers)
1. Add Slime/RayCast2D twice, rename to RayCastLeft and RayCastRight
1. Set collision mask of the raycasts to 9 (enemy layer); add layer 9 to physics layer of WorldTileSet scene too!  
1. Add Slime/AnimationPlayer and add *default* animation
1. Add Script
    ```
    class_name Slime extends Node2D

    @onready var ray_cast_right: RayCast2D = $RayCastRight
    @onready var ray_cast_left: RayCast2D = $RayCastLeft
    @onready var sprite: Sprite2D = $Sprite2D

    var speed := 40
    var direction := 1

    func _physics_process(delta: float) -> void:
        
        if ray_cast_right.is_colliding():
            direction = -1 
        if ray_cast_left.is_colliding():
            direction = 1 
        sprite.scale.x = direction
        position.x += delta * direction * speed
    ```
1. Add hurtbox and appropriate shape

#### Killing Enemies

1. Add a hurtbox to player and set mask to 9/enemy, add shape
1. Add hitbox to enemy with shape
1. Add a die animation that queue_frees the boxes immediately, and the enemy at the end
1. Hook up script
```
class_name Slime extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed := 40
var direction := 1
var hp := 1

func _ready() -> void:
	hit_box.hit.connect(_take_hit)

func _physics_process(delta: float) -> void:
	
	if ray_cast_right.is_colliding():
		direction = -1 
	if ray_cast_left.is_colliding():
		direction = 1 
	sprite.scale.x = direction
	position.x += delta * direction * speed
	

func _take_hit(_damage: int) -> void:
	hp -= _damage
	if hp <= 0:
		speed = 0
		animation_player.play("die")
```
<!-- MAKE ENEMIES KILLABLE; hurtbox -> player, hitbox & hp -> enemy -->



# Platforms 

1. New 2D scene animatable body 2d root callled platform
1. platform/sprite2D and sprites
1. platform/collisionshape2d and shape
1. In collisionshape > shape > resource, set local to scene
1. Add script
    ```
    @tool
    class_name Platform extends AnimatableBody2D

    enum WIDTH {narrow, wide}
    enum STYLE {grass, sand, lava, ice}

    @export var width := WIDTH.wide:
        set(_width):
            width = _width
            _update_width()
            
    @export var style := STYLE.grass:
        set(_style):
            style = _style
            _update_style()
            
    @onready var sprite: Sprite2D = $Sprite2D
    @onready var collision_shape: CollisionShape2D = $CollisionShape2D

    func _ready() -> void:
        _update_width()
        _update_style()


    func _update_width() -> void:
        var width_in_px := 16 if width == WIDTH.narrow else 32
        
        if sprite:
            sprite.region_rect.size.x = width_in_px
            sprite.region_rect.position.x = width_in_px-16	
        if collision_shape:
            collision_shape.shape.size.x = width_in_px


    func _update_style() -> void:
        if sprite:
            sprite.region_rect.position.y = style*16

    ```
1. Add to maps and add animationplayer to move if needed



# Add camera limits

1. Add a levelmanager as an autoload
```
extends Node

var current_bounds : Array[Vector2]

signal bounds_changed(bounds: Array[Vector2])

func update_level_bounds(bounds: Array[Vector2]) -> void:
	current_bounds = bounds
	bounds_changed.emit(current_bounds)
```
1. Add a level script to root node on levels
```
class_name Level extends Node2D

@onready var tile_sets: Node2D = $TileSets


func _ready() -> void:
	LevelManager.update_level_bounds(get_bounds())

func get_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	var left:int
	var right:int
	var top:int
	var bottom:int

	for t in tile_sets.get_children():
		if is_instance_of(t, TileMapLayer):
			left = min(left, (t.get_used_rect().position * t.rendering_quadrant_size)[0])
			right = max(right, (t.get_used_rect().end * t.rendering_quadrant_size)[0])
			top = min(top, (t.get_used_rect().position * t.rendering_quadrant_size)[1])
			bottom = max(bottom, (t.get_used_rect().end * t.rendering_quadrant_size)[1])
	
	bounds.append(Vector2(left, top))
	bounds.append(Vector2(right, bottom))
	
	return bounds
```
1. Add a script to player camera
```
class_name PlayerCamera extends Camera2D

func _ready() -> void:
	LevelManager.bounds_changed.connect(_update_limits)
	_update_limits(LevelManager.current_bounds)


func _update_limits(bounds: Array[Vector2]) -> void:
	if bounds == []:
		return
		
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
```