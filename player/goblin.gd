class_name Goblin
extends CharacterBody2D

# On ready vars
@onready var sprite: Sprite2D = $GoblinSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
# Export vars -> can edit on Inspector
@export var speed: float = 3.0
# Character vars
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var input_vector: Vector2 = Vector2(0, 0)

func _process(delta: float) -> void:
	# Call to read_input func that reads player input
	read_input()
	# Call to play_anim to update sprite animation
	play_run_anim()
	update_attack_cd(delta)
	
func _physics_process(delta: float) -> void:	
	# use input vector to determine directional velocity
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()
	
	# Attack
	if Input.is_action_just_pressed("attack"):
		attack()
		
func attack() -> void:
	# Check if attacking to stop bashing
	if is_attacking:
		return
	
	# Play attack anim, set the cooldown and update flag
	animation_player.play("attack_h")
	attack_cooldown = 0.6
	is_attacking = true

func read_input() -> void:
	# Get input vector aka input direction
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
	# Setup deadzone, check absolute value of input vector and if it's below deadZone, zero it
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0.0

	# Update is_running flag
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
func play_run_anim() -> void:
	# Play anim
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")
	
	# Flip sprite if facing left
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
			
func update_attack_cd(delta: float) -> void:
	# Timer for attack cooldown
	# Subtract time since last frame from attack cooldown until it's below 0, then update attacking status
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")
