extends KinematicBody2D

const GRAVITY = 300
const INIT_SPEED = 150
const JUMP_HEIGHT = 450

var speed = INIT_SPEED
var mass = 0

var motion = Vector2(0,0)

signal died

onready var tweenStretchY = get_node("tweenStretchY")
onready var tweenStretchX = get_node("tweenStretchX")

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	motion = Vector2(speed, GRAVITY)
	
	tweenStretchY.interpolate_property(self, "transform/scale", get_scale(), Vector2(1,2.5), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tweenStretchX.interpolate_property(self, "transform/scale", get_scale(), Vector2(2,2.5), 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	
	connect("grabbed", self, "powerup_grabbed")
	
func _input(event):
	if event.is_action_pressed("ui_down"):
		print("pressed")
		motion.y = -400
	
func _fixed_process(delta):
	motion.y += 15 + mass
	move(motion * delta)
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion * delta)
		emit_signal("died")
		queue_free()
		
func powerup_grabbed():
	tweenStretchY.start()
	tweenStretchX.start()
	mass = 20
	