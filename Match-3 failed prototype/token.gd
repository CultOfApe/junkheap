extends Label

var type
var gridPos = Vector2()

var status = "none"
var spriteSize = Vector2()
var mousePos = Vector2()

func _ready():
	spriteSize = self.get_size()
	set_process(true)

func _process(delta):
	if status == "dragging":
		set_global_pos(mousePos - spriteSize / 2)

func _input_event(event):

	if event.global_pos > get_global_pos() and event.global_pos < get_global_pos() + spriteSize:
		if event.type == InputEvent.MOUSE_BUTTON:
			if event.button_index == BUTTON_LEFT:
				if event.pressed:
					accept_event()
					status = "pressed"
	
	if status == "pressed" and event.type == InputEvent.MOUSE_MOTION:
		accept_event()
		status = "dragging"
	
	if event.type == InputEvent.MOUSE_BUTTON and !event.pressed:
		accept_event()
		status = "released"
		
	mousePos = event.global_pos


