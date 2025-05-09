class_name Ui
extends CanvasLayer

@onready var feedback_label := $Control/Label

func show_feedback(text: String):
	feedback_label.text = text
	feedback_label.visible = true
	
	var style = feedback_label.get_theme_stylebox("normal")
	
	if text == "Fail":
		style.bg_color  = Color(1.0, 0.0, 0.0)
		style.border_color = Color(1.0, 0.0, 0.0)
	elif text == "Perfect":
		style.bg_color  = Color(1.0, 0.78, 0.0)
		style.border_color = Color(1.0, 0.78, 0.0)
	elif text == "Good":
		style.bg_color  = Color(0.5, 0.0, 0.5)
		style.border_color = Color(0.5, 0.0, 0.5)

	feedback_label.add_theme_stylebox_override("normal", style)
	
	# Ocultar después de 0.5 segundos
	await get_tree().create_timer(0.3).timeout
	feedback_label.visible = false
