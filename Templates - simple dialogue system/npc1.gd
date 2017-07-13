extends Area2D

signal look_at(a)
signal dialogue(a,b)

func _ready():
	pass

func _on_npc1_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("dialogue", "res://npc1.json","a")

	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_RIGHT and event.is_pressed():
		emit_signal("look_at", "This is an NPC")
