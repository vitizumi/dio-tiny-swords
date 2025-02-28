class_name Player
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea

var was_running: bool = false
var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var input_vector: Vector2 = Vector2(0, 0)

@export var speed: float = 3
@export var sword_damage: int = 2
@export var health: int = 50
@export var max_health: int = 100
@export var death_prefab: PackedScene

func _process(delta: float) -> void:
	GameManager.player_position = position
	
	#Read Inputs
	read_input()
	
	#Countdown pra atk cd
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")
			
	#Play moveidle anim
	play_move_anim()

	#Attack
	if Input.is_action_just_pressed("attack"):
		attack()
		
	take_damage(delta)
	
func _physics_process(delta: float) -> void:	
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()

func attack() -> void:
	if is_attacking:
		return
	
	animation_player.play("attack_side_1")
	attack_cooldown = 0.6
	
	is_attacking = true
	
func read_input() -> void:
	# Obter input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Setup deadzone
	var deadZone = 0.15
	if abs(input_vector.x) < deadZone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadZone:
		input_vector.y = 0.0
		
	# Atualizar is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_move_anim() -> void:			
	# Play anim
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")
	
	# Flip sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func deal_damage() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.damage(sword_damage)
				
func take_damage(delta: float) -> void:
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	hitbox_cooldown = 0.5
	
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)

func damage(amount) -> void:
	if health <= 0: return
	
	health -= amount
	print("Dmg!", amount, "HP: ", health)

	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		die()

func die() -> void:
	if death_prefab: 
		var death_obj = death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)
		
	queue_free()

func heal(amount: float) -> int:
	health += amount
	if health >= max_health:
		health = max_health
	print("Heal!", amount, "HP: ", health, "/", max_health)
	return health
