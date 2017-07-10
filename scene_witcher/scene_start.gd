extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Start_button_down():
	global.goto_scene("scene_01.tscn")

func _on_Quit_button_down():
	get_tree().quit()
