class_name PulseColision

extends Area2D

@onready var pulse_audio_stream = get_parent().get_node("Pulse")

var is_perfect
var is_good

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	
func play_note_70ms():
	pulse_audio_stream.play()
	await get_tree().create_timer(0.07).timeout
	pulse_audio_stream.stop()

func _on_area_entered(area):
	if area.name == "Perfect":
		if area.get_parent().name == "Green":
			if area.get_parent().get_parent().name == "PlayerGuide":
				play_note_70ms()
	if area.name == "Perfect":
		is_perfect = true
	elif area.name == "Good":
		is_good = true

func _on_area_exited(area):
	if area.name == "Perfect":
		is_perfect = false
	elif area.name == "Good":
		is_good = false
