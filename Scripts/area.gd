class_name Area

extends Node2D

@onready var player_guide = $PlayerGuide
@onready var enemy_guide = $EnemyGuide

var colors = {
	"Yellow":672,
	"Blue":640,
	"Red":608,
	"Green":576
}

var attacks = JSON.parse_string(FileAccess.open("res://Assets/notes_detected.json", FileAccess.READ).get_as_text())
var start_time = 0.0
var is_attacking = false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_attack"):
			spawn_attack()

func spawn_attack():
	is_attacking = true
	var player = get_parent().get_node("Enemy/AudioStreamPlayer2D")
	player.play()
	for atk in attacks:
		var tiempo_objetivo = atk["time_seconds"]
		push_warning(player.get_process_delta_time())
		var tiempo_actual = Time.get_ticks_msec() / 1000.0
		var tiempo_faltante = tiempo_objetivo - (tiempo_actual - start_time)
		if tiempo_faltante > 0:
			await get_tree().create_timer(tiempo_faltante).timeout
			var attack = preload("res://Scenes/attack.tscn").instantiate() as Attack_Node
			var sprite = attack.get_node("Sprite2D") as Sprite2D
			sprite.region_rect  =Rect2(Vector2(colors["Red"],0), Vector2(32,32))
			var point = enemy_guide.get_node("Red")
			attack.position = Vector2(point.position.x, enemy_guide.position.y + enemy_guide.get_child(2).position.y)
			add_child(attack)

	print("✅ ¡Todas las notas ejecutadas!")
	is_attacking = false
