extends Node2D

@onready var anima = $AnimatedSprite2D
var is_attacking = false
var is_dodging = false
var is_blocking = false

func _ready() -> void:
	anima.play("idle")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_attack") and not is_attacking:
		attack(select_target())
	if Input.is_action_just_released("ui_attack"):
		is_attacking = false
		anima.flip_h = false
		anima.play("idle")
	if Input.is_action_pressed("ui_block") and not is_blocking:
		block(select_target())
	if Input.is_action_just_released("ui_block"):
		is_blocking = false
		anima.flip_h = false
		anima.play("idle")
	if Input.is_action_pressed("ui_dodge") and not is_dodging:
		dodge(select_target())
	if Input.is_action_just_released("ui_dodge"):
		is_dodging = false
		anima.flip_h = false
		anima.play("idle")

func select_target() -> String:
	if Input.is_action_pressed("ui_right"):
		return "right"
	elif Input.is_action_pressed("ui_left"):
		return "left"
	elif Input.is_action_pressed("ui_down"):
		return "down"
	elif Input.is_action_pressed("ui_right_up"):
		return "right_up"
	elif Input.is_action_pressed("ui_left_up"):
		return "left_up"
	return "none"

func attack(name_anima:String) -> void:
	if name_anima == "none":
		return
	
	is_attacking = true
	
	match name_anima:
		"right_up":
			anima.play("up_attack")
		"right":
			anima.play("down_attack")
		"left_up":
			anima.flip_h = true
			anima.play("up_attack")
		"left":
			anima.flip_h = true
			anima.play("down_attack")

func block(name_anima:String) -> void:
	if name_anima == "none":
		return
	
	is_blocking = true
	
	match name_anima:
		"right_up":
			anima.play("up_block")
		"right":
			anima.play("down_block")
		"left_up":
			anima.flip_h = true
			anima.play("up_block")
		"left":
			anima.flip_h = true
			anima.play("down_block")

func dodge(name_dodge:String) -> void:
	if name_dodge == "none":
		return
		
	is_dodging = true
	
	match name_dodge:
		"right":
			anima.play("side_dodge")
		"down":
			anima.play("dodge_down")
		"left":
			anima.flip_h = true
			anima.play("side_dodge")
