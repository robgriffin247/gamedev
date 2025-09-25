class_name PlayerStateMachine extends Node

var current_state: PlayerState
var previous_state: PlayerState
var states: Array[PlayerState]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	# On tick, change state if .process() returns a PlayerState
	change_state(current_state.process(delta))


func _physics_process(delta: float) -> void:
	# On tick, change state if .physics() returns a PlayerState
	change_state(current_state.physics(delta))


func _unhandled_input(event: InputEvent) -> void:
	# Change state if .handle_input() returns a PlayerState
	change_state(current_state.handle_input(event))


# Initialise the state machine, setting the initial state to states[0] (idle)
func initialize(_player: Player) -> void:
	states = []
	
	# Get all the PlayerStates
	for child in get_children():
		if child is PlayerState:
			states.append(child)
	
	if states.size() > 0:
		states[0].player = _player
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT



# Handles chaning of PlayerState
func change_state(new_state: PlayerState) -> void:
	# Control for when PlayerState does not change
	if new_state == null || new_state == current_state:
		return
	
	# From here runs only if PlayerState changed:
	
	# Exit PlayerState if there is a current state
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	
	current_state.enter()
	
