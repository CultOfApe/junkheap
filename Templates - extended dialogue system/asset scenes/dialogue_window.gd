extends Label

signal dialogueClicked

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _on_dialogue_clicked():
#	print("clicked")
#	emit_signal("clicked")


func _on_dialogue_input_event( ev ):
	if ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == BUTTON_LEFT and ev.is_pressed():
		emit_signal("dialogueClicked")
