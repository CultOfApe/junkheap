extends Label

var num_reply = 0 #this is set to another number in world.gd, when the label is instanced, to identify the reply for when you pick it later
signal reply_selected(a)

func _ready():
	pass

func _on_reply_mouse_enter():
	add_color_override("font_color", Color(1,0,1))

func _on_reply_mouse_exit():
	add_color_override("font_color", Color(1,1,1))

func _on_reply_input_event( ev ):
	if ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == BUTTON_LEFT and ev.is_pressed():
		print(num_reply)
		emit_signal("reply_selected",num_reply)
