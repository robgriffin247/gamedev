# Merge Conflict DevLog


## 2025-03-27

### feat-001/Project Setup

Created a new project in Godot; using forward+ renderer, added git version control 
to directory and connected to a [github repo](https://github.com/robgriffin247/merge_conflict).
Then added a `Node2D` called `playground` to the root of the project to serve as a 
node for testing the game.
Playground node was saved as a scene to a general_nodes/scenes directory; 
general_nodes will be used to store general purpose assets. Y Sorting Enabled was set to true for the `Playground` node.

Set Project Settings/
- General/Rendering/Textures/Default Texture Filter to *Nearest*; suitable for pixel art
- General/Display/Window/Size/Viewport width to *336*
- General/Display/Window/Size/Viewport height to *189*
- General/Display/Window/Stretch/Mode to *viewport*; won't stretch the pixel art
- General/Display/Window/Window Width Override (advanced settings) to *1152*
- General/Display/Window/Window Height Override (advanced settings) to *648*


### feat-001/Adding a Moveable Player

Created a `player` scene, saved to `./player/scene` and added to the `playground` node.
`Sprite2D` used over `AnimatedSprite2D` as it makes it easier to allow more complexity; the `AnimatedSprite2D` would be easy to setup but more constrained and will be better suited to animated pickups and simpler characters.

```
player: CharacterBody2D
|- CollisionShape2D
|- Sprite2D
```

Added a sprite sheet for player character *Alex* from [ModernOffice Asset Pack](https://limezu.itch.io/modernoffice).
Used the complete sprite sheet (`./player/sprites/Alex_16x16.png`) and animation 
settings on `Sprite2D` to setup frames.
Added inputs to the Project Settings/Input map for directions (up, down, left, 
right) mapped to arrow keys.
Added a `Player` class (`./player/scripts/player.gd`) extending `CharacterBody2D` 
to control the player. The `direction` and `velocity` are calculated with frame (process-ticks) and player moved with each physics-tick. The `direction` is calculated into a `Vector2` using two `Input.get_axis()` calls, then `normalized()` so diagonal movement goes at the same speed as cardinal movement.
`Player` motion mode was set to floating, suitable for 2D-isometric games.

## 2025-03-28

### feat-002/Idle and Walk Player Animations

Added and `AnimationPlayer` Node to `Player`, then added animations `idle_down`, `idle_up` and `idle_side` to the `AnimationPlayer`. Animations set using keys on the frame propery of `Sprite2D`. The spritesheet includes animations for `left` and `right`, but using `side` (from right to left) and adding flip to sprite based on direction.

- `idle_up`: 30-35
- `idle_side`: 36-41
- `idle_down`: 42-47
- `walk_up`: 54-59
- `walk_side`: 60-65
- `walk_down`: 66-71

Added `state` and `cardinal_direction` variables, `onready` references to `Sprite2D` and `AnimationPlayer`, and `set_state()`, `set_direction()`, `update_animation()` and `animation_direction()` functions. Much of this will be modified with the implementation of a state machine. The `set_*()` functions are used to check if the properties need updating; they return `false` if direction/state do not change. Flipped sprite with `scale` rather than `flip_h` to make it also flip any child nodes (e.g. hit/hurt boxes, animations, sprites).


### feat-003/ Add Player State Machine

The `PlayerStateMachine` class allows code relating to player state (walk, idle, attack, jump etc.) to be broken out from the `player.gd` script, orchestrating the state of the player. The player can only be in one state at a time. Each state has a class (extending a `PlayerState` class), e.g. `PlayerStateWalk`.

The state machine initialises with all player states and sets the state to idle. It changes the players state as needed on process, physics and input. For example, user pressed attack button so changes player state to attack, or player was hit by enemy on process tick so changes to stunned.

In `player.gd` added reference to `StateMachine` and removed `state`, `move_speed`, `set_state()`, initialised the state machine when player node enters the scene (`_ready()`). The `_process()` only derives direction.

Created idle and walk states, attaching scripts for these states defining what happens in those states, such as defining `move_speed` and `velocity`.


### feat-004/ Add Tilemaps

Created a `TileMapLayer` scene called `Office01`. Created own set of wall and floor tiles in 16x16 pixels. Added Physics Layer, setting layer to `5` (renaming layer to walls) and removing the mask, and set `Player` node mask to `5`. Also added camera to `Player` scene to make camera follow player.

### feat-005/ Add PlayerSpawn

Created a node and script(s) to automatically spawn the player at a chosen position, so only one instance exists and position deterined by playerspawn scene in each level.


### feat-006/ Add Camera Limits


### feat-007/ Add Level Transitions
