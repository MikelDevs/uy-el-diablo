class_name Area

extends Node2D

@onready var player_guide = $PlayerGuide
@onready var enemy_guide = $EnemyGuide
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var colors = {
	"Yellow": 544,
	"Blue": 512,
	"Red": 480,
	"Green": 448
}

var attacks = JSON.parse_string(FileAccess.open("res://Assets/notes_detected.json", FileAccess.READ).get_as_text())
var is_attacking = false

func _ready() -> void:
	spawn_attack()
	
func spawn_attack():
	is_attacking = true
	var music_player = get_parent().get_node("Enemy/AudioStreamPlayer2D")
	#music_player.play()
	animation_player.play("PulseAnimation")
	
	is_attacking = false
