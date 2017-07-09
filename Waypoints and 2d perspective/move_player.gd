#bug01 if I hoverObject while player is walking through waypoints, player will stop at next waypoint, and waypoint sprites won´t go away
extends KinematicBody2D

var pSpeed = 500
var pRelativeSize
var dirVector
var mousePos = Vector2(0,0)
var wpArray = Vector2Array()
var wpArrayItem
var isTweenRunning = false
var isWaypointSet = false
var arrayPos = 0
var objectHover

onready var tween = get_node("Tween")
var wp = preload("res://wp.tscn")
onready var wpContainer = get_node("/root/Node/wpContainer")

func _ready():
	set_process(true)
	set_process_input(true)
	objectHover = false
	var pRelativeSize = get_scale() * (0.5 + get_pos().y / get_viewport().get_rect().size.y )
	set_scale(pRelativeSize)

func _process(delta):
	#if CTRL is not pressed, check if there is anything in wpArray, and if so move to wps
	if !Input.is_action_pressed("ui_modifier"):
		if !isTweenRunning:
			if isWaypointSet:
				tweenMove(wpArray[wpArrayItem])
				if wpArrayItem < wpArray.size()-1:
					wpArrayItem += 1
				else:
					isWaypointSet = false
					wpArray.resize(0)
		else:
			pass
	
func _input(event):
	#detect mouseclick, and store position under mouse
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed():
		if Input.is_action_pressed("ui_modifier"):
			pass
		else:
			mousePos = event.pos
			tweenMove(mousePos)

	#detect if CTRL+LMB pressed at the same time and if they are append mouseposition to waypoint array
	if Input.is_action_pressed("ui_modifier"):
		if event.type == InputEvent.MOUSE_BUTTON:
			if event.button_index == BUTTON_LEFT and event.pressed:
				mousePos = event.pos
				
				#append mousePos to array, then signal that isWaypointSet and first item should be 0
				wpArray.append(mousePos)
				isWaypointSet = true
				wpArrayItem = 0
				
				#instance a spinning circle animation as waypoint visual indicator, set sprite scale relative to location y
				var wpNode = wp.instance()
				wpContainer.add_child(wpNode) 
				var wpNodeContainer = wpContainer.get_child(wpContainer.get_child_count()-1)
				var wpNodeScale = wpNodeContainer.get_scale() 
				wpNodeContainer.set_scale(wpNodeScale * (0.5 + mousePos.y / get_viewport().get_rect().size.y ))
				wpNodeContainer.set_pos(mousePos)
			
func tweenMove(waypoint):
	var distance = get_global_pos().distance_to(waypoint)
	var time = distance / pSpeed
	var scaleMult = 0.5 + waypoint.y / get_viewport().get_rect().size.y
	
	swap_anim(waypoint - get_pos())
	
	tween.interpolate_property(self,"transform/pos", get_pos(), waypoint, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(self,"transform/scale", get_scale(), Vector2(scaleMult, scaleMult), time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	if objectHover == false:
		tween.start()
		isTweenRunning = true
	else:
		tween.stop(self,"transform/pos")
		tween.stop(self,"transform/scale")
		
func swap_anim(dirVec):
	if abs(dirVec.x) < abs(dirVec.y):
		if dirVec.y > 0:
			get_node("sprite").set_animation("walk_down")
		else:
			get_node("sprite").set_animation("walk_up")
	else:
		if dirVec.x > 0:
			get_node("sprite").set_animation("walk_right")
		else:
			get_node("sprite").set_animation("walk_left")
		
func _on_Tween_tween_complete( object, key ):
	isTweenRunning = false

func _on_friend_mouse_enter():
	objectHover = true
	
func _on_friend_mouse_exit():
	objectHover = false
