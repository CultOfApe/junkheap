extends StaticBody2D

var my_label_node
var playerClicked = false

func _ready():

	pass
	
func _on_friend_mouse_enter():
	
	my_label_node = Label.new()
	add_child(my_label_node)
	my_label_node.set_owner(self)
	if !playerClicked:
		my_label_node.set_text('Hey friend! Are you looking at me?')
	else:
		my_label_node.set_text("Don´t you dare clicking me again!")
	my_label_node.set_global_pos(get_pos() + Vector2(-90,-50))
	
func _on_friend_mouse_exit():
	my_label_node.queue_free()

func _on_friend_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_LEFT and event.pressed:
			my_label_node.set_text("Hey! Stop clicking me :(")
			playerClicked = true
			
				
