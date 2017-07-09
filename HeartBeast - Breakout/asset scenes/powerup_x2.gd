extends RigidBody2D

signal powerup_x2

func _ready():
	pass

func _on_powerup_x2_body_enter( body ):
	if body.get_name() == "paddle":
		emit_signal("powerup_x2")
		queue_free()
