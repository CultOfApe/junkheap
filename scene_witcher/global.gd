extends Node

var current_scene

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_exit"):
		get_tree().quit()

func goto_scene(scene):
    get_tree().change_scene("res://"+scene)
