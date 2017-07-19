extends Area2D

signal look_at(a)
signal dialogue(a,b,c)

var identity = {"dialogue": "res://dialogue/npc1.json", "branch": "a", "name": "NPC1"}

func _ready():
	pass

func _on_npc1_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("dialogue", identity.dialogue, identity.branch, identity.name)

	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_RIGHT and event.is_pressed():
		emit_signal("look_at", "This is an NPC")