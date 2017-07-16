extends Label

var num_reply = 0 #this is set to another number in world.gd, when the label is instanced, to identify the reply for when you pick it later
signal reply_selected(a)
signal reply_mouseover(a,b)

var dumb_godot = 0

func _ready():
	pass

func _on_reply_mouse_enter():
	add_color_override("font_color", Color(1,0,1))
	emit_signal("reply_mouseover","TRUE",num_reply)

func _on_reply_mouse_exit():
	add_color_override("font_color", Color(1,1,1))
	emit_signal("reply_mouseover","FALSE",num_reply)

func _on_reply_input_event( ev ):
	if ev.type == InputEvent.MOUSE_BUTTON:
		if ev.button_index == BUTTON_LEFT and ev.is_pressed():
			emit_signal("reply_selected",num_reply)
		else:
			pass
