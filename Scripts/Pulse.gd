class_name Pulse
extends Node2D

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var base : Area2D = $Base
@onready var anima : AnimationPlayer = $AnimationPlayer

signal onGoodPulseStart
signal onGoodPulseEnd
signal onPerfectPulseStart
signal onPerfectPulseEnd

func _ready():
	base.connect("area_entered", Callable(self, "_on_area_entered"))
	base.connect("area_exited", Callable(self, "_on_area_exited"))

func _on_area_entered(area):
	if area.name == "Perfect":
		emit_signal("onPerfectPulseStart")
		play_note()
	elif area.name == "Good":
		emit_signal("onGoodPulseStart")

func _on_area_exited(area):
	if area.name == "Perfect":
		emit_signal("onPerfectPulseEnd")
	elif area.name == "Good":
		emit_signal("onGoodPulseEnd")

func play_note():
	audio.play()
	await get_tree().create_timer(0.05).timeout
	audio.stop()

func start():
	anima.play("pulse")
