class_name Attack_Node
extends Area2D

# Incremento de la escala (en este caso, reducimos 0.1 por fotograma)
var tamaño_decremento = 1

func _ready() -> void:
	scale = Vector2(2.5,2.5)

func _process(delta):
	# Verifica si la escala es mayor que 0
	if scale.x > 0.5 and scale.y > 0.5:
		scale -= Vector2(tamaño_decremento, tamaño_decremento) * delta
	else:
		# Aquí puedes ocultar el objeto o destruirlo cuando la escala sea 0
		queue_free()  # Esto destruirá el nodo
		# O también puedes desactivarlo
		# hide()  # Esto ocultará el objeto, pero no lo destruirá
