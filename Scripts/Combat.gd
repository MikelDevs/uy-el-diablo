extends Node2D

@onready var witch : Enemy = preload("res://Scenes/Enemy.tscn").instantiate()
@onready var player : Player = preload("res://Scenes/Player.tscn").instantiate()
@onready var ui : Ui = $Ui
@onready var anima : AnimatedSprite2D = $AnimatedSprite2D
@onready var pulse : Pulse = $Pulse

const _default_player_position : Vector2 = Vector2(200, 900)
const _default_enemy_position : Vector2 = Vector2(1200, 900)

var is_started : bool = false
var combo : Array = []
var is_pulsed : bool = false

func _ready() -> void:
	witch.enemy_data = preload("res://Attributes/Enemies/Witch.tres")
	player.player_data = preload("res://Attributes/Player/Player.tres")
	
	pulse.connect("onGoodPulseStart", _on_good_pulse_start)
	pulse.connect("onGoodPulseEnd", _on_good_pulse_end)
	pulse.connect("onPerfectPulseStart", _on_perfect_pulse_start)
	pulse.connect("onPerfectPulseEnd", _on_perfect_pulse_end)
	
	anima.play()
	
	set_characters()
	
	prepare()
	
func prepare() -> void:
	var numbers = ["3", "2", "1", "START!"]
	var label_start = ui.get_node("Control/text")
	label_start.visible = true
	for text in numbers:
		label_start.text = text
		await get_tree().create_timer(1.0).timeout 
	start()

func set_characters() -> void:
	witch.position = _default_enemy_position
	player.position = _default_player_position
	add_child(player)
	add_child(witch)
	move_child(witch, 1)
	move_child(player, 1)

func start():
	var label_start = ui.get_node("Control/text")
	label_start.visible = false  
	is_started = true
	pulse.start()

func _on_good_pulse_start():
	push_warning("Pulse G Start")

func _on_good_pulse_end():
	push_warning("Pulse G End")

func _on_perfect_pulse_start():
	push_warning("Pulse P Start")

func _on_perfect_pulse_end():
	push_warning("Pulse P End")
