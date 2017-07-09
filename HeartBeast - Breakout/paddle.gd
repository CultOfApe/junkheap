extends KinematicBody2D

const BALL_SCENE = preload("res://asset scenes/ball.tscn")

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
func _fixed_process(delta):
	var y = get_pos().y
	var x = get_viewport().get_mouse_pos().x
	set_pos(Vector2(x, y))

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed():
		var ball = BALL_SCENE.instance()
		ball.set_pos(get_pos() - Vector2(0, 16))
		get_tree().get_root().get_node("world").get_node("balls").add_child(ball)
		
func _powerup_x2():
	var effect = get_node("/root/world").get_node("paddle").get_node("tween")
	effect.interpolate_property(self, "transform/scale", get_scale(),Vector2(4,2), 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	print("it runs!")
	effect.start()
	
		
