class_name Attack_Node
extends Area2D

@export var speed: float = 300 # velocidad de bajada

func _process(delta):
	position.y += speed * delta
