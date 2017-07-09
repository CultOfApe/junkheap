extends Area2D

signal grabbed

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Area2D_body_enter( body ):
	emit_signal("grabbed")
	queue_free()
