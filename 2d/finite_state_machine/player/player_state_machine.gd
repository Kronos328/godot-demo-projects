extends "res://state_machine/state_machine.gd"

onready var idle = $Idle
onready var move = $Move
onready var jump = $Jump
onready var stagger = $Stagger
onready var attack = $Attack

func _ready():
	for state in get_children():
		states_map[state.name.to_lower()] = state


func _change_state(state_name):
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["stagger", "jump", "attack"]:
		states_stack.push_front(states_map[state_name])
	if state_name == "jump" and current_state == move:
		jump.initialize(move.speed, move.velocity)
	._change_state(state_name)


func _unhandled_input(event):
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.
	if event.is_action_pressed("attack"):
		if current_state in [attack, stagger]:
			return
		_change_state("attack")
		return
	current_state.handle_input(event)
