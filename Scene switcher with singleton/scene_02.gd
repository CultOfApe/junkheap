extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Next_button_down():
	global.goto_scene("scene_03.tscn")

func _on_Previous_button_down():
	global.goto_scene("scene_01.tscn")