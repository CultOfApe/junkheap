extends Node2D

onready var birdTemplate = load("res://bird.tscn")
onready var powerupTemplate = load("res://powerup_bigger.tscn")

func _ready():
	
	set_fixed_process(true)
	set_process_input(true)
	
	var bird = birdTemplate.instance()
	bird.set_pos(Vector2(20, 50))
	add_child(bird)
	
	var powerup = powerupTemplate.instance()
	powerup.set_pos(Vector2(250, 150))
	add_child(powerup)
	
	powerup.connect("grabbed", bird, "powerup_grabbed")
	bird.connect("died", self, "respawn")

func _input(event):
	pass
	
func _fixed_process(delta):
	pass
	
func respawn():
	var bird = birdTemplate.instance()
	bird.set_pos(Vector2(20, 50))
	add_child(bird)
	bird.connect("died", self, "respawn")
	
	
