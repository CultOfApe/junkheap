extends RigidBody2D

onready var powerupx2 = preload("res://asset scenes/powerup_x2.tscn")

const SPEEDUP = 10
const MAXSPEED = 340

func _ready():
	randomize()
	set_fixed_process(true)

func _fixed_process(delta):
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.is_in_group("bricks"):
			get_node("/root/world").score +=5
			body.queue_free()
			
			if randi()%10 < 2:
				var powerup = powerupx2.instance()
				powerup.set_pos(body.get_pos())
				get_tree().get_root().get_node("world").add_child(powerup)
				var paddle = get_tree().get_root().get_node("world").get_node("paddle")
				powerup.connect("powerup_x2", paddle, "_powerup_x2")
				
				
		elif body.get_name() == "paddle":
			var speed = get_linear_velocity().length()
			var direction = get_pos() - body.get_node("anchor").get_global_pos()
			var velocity = direction.normalized() * min(speed+SPEEDUP, MAXSPEED)
			set_linear_velocity(velocity)
	
	if get_pos().y > get_viewport_rect().size.y:
		queue_free()

