extends Node2D

@onready var witch : Enemy = preload("res://Scenes/Enemy.tscn").instantiate()
@onready var player : Player = preload("res://Scenes/Player.tscn").instantiate()
@onready var ui : Ui = $Ui
@onready var pulse : Pulse = $Pulse
@onready var combo_note_ui = preload("res://Scenes/ComboNoteUi.tscn")
@onready var sprites = preload("res://Sprites/player.png")
@onready var pulse_score = preload("res://Scenes/PulseScore.tscn")
@onready var stock_default = preload("res://Scenes/Stock.tscn")
@onready var player_hp : ProgressBar = ui.get_node("Control/PlayerHp")
@onready var player_stock : VBoxContainer = ui.get_node("Control/PlayerStock")
@onready var enemy_hp : ProgressBar = ui.get_node("Control/EnemyHp")
@onready var enemy_stock : VBoxContainer = ui.get_node("Control/EnemyStock")
@onready var combo_ui = ui.get_node("Control/Combo")

const _default_player_position : Vector2 = Vector2(750, 900)
const _default_enemy_position : Vector2 = Vector2(1050, 500)

var is_started : bool = false   #if the game is started
var is_perfect : bool = false
var turn: int = 0
var player_turn : bool = false
var is_good : bool = false
var combo : Array = []
var is_pulsed : bool = false
var last_pulsed = false
var is_enemy_attacking = false
var attack_info = {
	"a":{
		"name": "Blue",
		"score": false,
		"rect": 512,
		"key": "a"
	},
	"w": {
		"name": "Green",
		"score": false,
		"rect": 448,
		"key": "w"
	},
	"e": {
		"name": "Red",
		"score": false,
		"rect": 480,
		"key": "e"
	},
	"f": {
		"name": "Yellow",
		"score": false,
		"rect": 544,
		"key": "f"
	}
}
var special_attacks = [
	["e","w","e","w","e",],
	["w","w","w","f","f",],
	["a","w","a","f","e",],
	["f","e","w","a","f",]
]

func _ready() -> void:
	witch.enemy_data = preload("res://Attributes/Enemies/Witch.tres")
	player.player_data = preload("res://Attributes/Player/Player.tres")
	
	pulse.connect("onGoodPulseStart", _on_good_pulse_start)
	pulse.connect("onGoodPulseEnd", _on_good_pulse_end)
	pulse.connect("onPerfectPulseStart", _on_perfect_pulse_start)
	pulse.connect("onPerfectPulseEnd", _on_perfect_pulse_end)
	player.connect("onAttack", _on_attack)
	
	set_characters()
	
	set_ui()
	
	set_turns()
	
	prepare()

func _process(delta: float) -> void:
	if player_turn:
		if player.current_stock < 1:
			end_turn()
	else:
		if not is_enemy_attacking:
			enemy_attack()

func end_turn() -> void:
	change_turn()
	process_notes(keys(combo))
	combo = []
	clear_stocks(combo_ui)
	player.restock()
	witch.restock()
	set_ui()
	
func keys(combo):
	var keys := []
	for nota in combo:
		keys.append(nota["key"])
	return keys

func prepare() -> void:
	var numbers = ["3", "2", "1", "START!"]
	var label_start = ui.get_node("Control/text")
	label_start.visible = true
	for text in numbers:
		label_start.text = text
		await get_tree().create_timer(1.0).timeout 
	start()

func set_turns() -> void:
	turn = 1
	if player.attr.speed > witch.attr.speed:
		player_turn = true
	elif player.attr.speed < witch.attr.speed:
		player_turn = false
	elif  player.attr.speed == witch.attr.speed:
		player_turn = rand_turn()
		
	set_turns_ui()

func change_turn() -> void:
	turn += 1
	player_turn = !player_turn
	
	set_turns_ui()

func set_turns_ui() -> void:
	var turn_ui: Label = ui.get_node("Control/turn")
	var turn_to: Label = ui.get_node("Control/turnTo")
	
	turn_ui.text = str(turn)
	
	if player_turn:
		turn_to.text = "YOUR TURN"
	else:
		turn_to.text = "ENEMY TURN"

func set_characters() -> void:
	witch.position = _default_enemy_position
	player.position = _default_player_position
	add_child(player)
	add_child(witch)
	move_child(witch, 1)
	move_child(player, 1)

func set_ui() -> void:
	clear_stocks(enemy_stock)
	clear_stocks(player_stock)
	
	for stock in player.current_stock:
		var stock_init = stock_default.instantiate()
		player_stock.add_child(stock_init)
	for stock in witch.current_stock:
		var stock_init = stock_default.instantiate()
		enemy_stock.add_child(stock_init)
	
	player_hp.value = calculate_hp_porcentage(player.attr.health, player.current_health)
	enemy_hp.value = calculate_hp_porcentage(witch.attr.health, witch.current_health)

func start():
	var label_start = ui.get_node("Control/text")
	label_start.visible = false  
	is_started = true
	pulse.start()

func _on_good_pulse_start():
	is_good = true

func _on_good_pulse_end():
	is_good = false

func _on_perfect_pulse_start():
	is_perfect = true

func _on_perfect_pulse_end():
	is_perfect = false

func enemy_attack():
	is_enemy_attacking = true
	await get_tree().create_timer(2.0).timeout
	change_turn()
	is_enemy_attacking = false

func _on_attack(attack:String):
	if not is_started or not player_turn or player.current_stock < 1:
		return
		
	is_pulsed = true
	last_pulsed = attack_info[attack].duplicate(true)
	

	
	var current_note : TextureRect = combo_note_ui.instantiate()
	current_note.texture  = new_tex(attack)
	
	var current_pulse_score : Label = pulse_score.instantiate()
	current_pulse_score.size = Vector2(80, 80)
	current_pulse_score.scale = Vector2(0.5, 0.5)
	current_pulse_score.position = Vector2(30, 30)
	var style = current_pulse_score.get_theme_stylebox("normal").duplicate(true)

	if is_perfect:
		last_pulsed.score = 100
		current_pulse_score.text = "PERFECT"
		style.bg_color  = Color(1.0, 0.78, 0.0)
		style.border_color = Color(1.0, 0.78, 0.0)
	elif is_good:
		last_pulsed.score = 90
		current_pulse_score.text = "GOOD"
		style.bg_color  = Color(0.5, 0.0, 0.5)
		style.border_color = Color(0.5, 0.0, 0.5)
	else:
		last_pulsed.score = 80
		current_pulse_score.text = "BAD"
		style.bg_color  = Color(0.6, 0.6, 0.6)
		style.border_color = Color(1.0, 1.0, 1.0)
		
	combo.push_back(last_pulsed)
	
	current_pulse_score.add_theme_stylebox_override("normal", style)
	current_note.add_child(current_pulse_score)
	
	combo_ui.add_child(current_note)
	
	player.current_stock -=1
	set_ui()

func clear_stocks(container):
	for child in container.get_children():
		child.queue_free()

func calculate_hp_porcentage(hp:float, current_hp:float) -> int:
	var hp_percent: int = int(ceil((current_hp / hp) * 100))
	return hp_percent

func rand_turn() -> bool:
	return randf() < 0.5

func new_tex(color:String) -> AtlasTexture:
	var tex = AtlasTexture.new()
	tex.atlas = sprites
	tex.region = Rect2(attack_info[color].rect, 0, 32, 32)
	tex.margin = Rect2(2, 2, 4, 4)
	return tex

func is_special_attack(notes) -> bool:
	for combo in special_attacks:
		if notes == combo:
			return true
	return false

func do_attack(count: int) -> void:
	var damage = 10 * count
	push_warning("Ataque básico de ", damage, " de daño.")

func heal(count: int) -> void:
	var heal_amount = 5 * count
	push_warning("Curación de ", heal_amount)

func apply_buff(count: int) -> void:
	push_warning("Buff aplicado por ", count, " turnos.")

func apply_debuff(count: int) -> void:
	push_warning("Debuff al enemigo por ", count, " turnos.")

func execute_special_combo(notes) -> void:
	# Aquí puedes definir efectos únicos por combo
	if notes == ["e","w","e","w","e",]:
		push_warning("¡Ataque triple!")
	elif notes == ["w","w","w","f","f",]:
		push_warning("¡Curación potenciada!")

func process_notes(notes) -> void:
	push_warning(notes)
	if is_special_attack(notes):
		push_warning("Combo especial activado!")
		execute_special_combo(notes)
	else:
		var counts := {
			"e": 0,
			"w": 0,
			"a": 0,
			"f": 0
		}
		for note in notes:
			if counts.has(note):
				counts[note] += 1
		
		push_warning(counts)
		
		# Aplicar efectos según cantidades
		if counts["e"] > 0:
			do_attack(counts["e"])
		if counts["w"] > 0:
			heal(counts["w"])
		if counts["a"] > 0:
			apply_buff(counts["a"])
		if counts["f"] > 0:
			apply_debuff(counts["f"])
