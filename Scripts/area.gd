class_name Area

extends Node2D

@onready var player_guide = $PlayerGuide
@onready var enemy_guide = $EnemyGuide
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_attacking = false

func start_combat():
	is_attacking = true
	#var music_player = get_parent().get_node("Enemy/AudioStreamPlayer2D")
	#music_player.play()
	animation_player.play("PulseAnimation")
	
	is_attacking = false
