class_name Goblin
extends CharacterBody2D

# On ready vars
@onready var sprite: Sprite2D = $GoblinSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var torch_area: Area2D = $TorchArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_prog_bar: ProgressBar = $HealthProgressBar
# Export vars -> can edit on Inspector
@export_category("Movement")
@export var speed: float = 3.0
@export_category("Attack")
@export var torch_damage: int = 2
@export var blast_damage: int = 2
@export var blast_interval: float = 30
@export var blast_scene: PackedScene
@export_category("Health")
@export var max_health: int = 100
@export var health: int = 100
@export var death_prefab: PackedScene
# Character vars
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var blast_cooldown: float = 0.0
var input_vector: Vector2 = Vector2(0, 0)

signal meat_collected(value:int)

func _ready() -> void:
	GameManager.goblin = self

func _process(delta: float) -> void:
	# Send position to the game manager class
	GameManager.player_position = position
	
	# Call to read_input func that reads player input
	read_input()
	# Call to check for attack
	update_attack_cd(delta)
	# Attack
	if Input.is_action_just_pressed("attack"):
		attack()
	# Call to play_anim to update sprite animation
	play_run_anim()
	
	# Check for taking damage
	hitbox_check(delta)
	
	update_blast(delta)
	
	health_prog_bar.max_value = max_health
	health_prog_bar.value = health
	
func _physics_process(delta: float) -> void:	
	# use input vector to determine directional velocity
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()
	
		
func attack() -> void:
	# Check if attacking to stop bashing
	if is_attacking:
		return
	
	# Play attack anim, set the cooldown and update flag
	animation_player.play("attack_h")
	attack_cooldown = 0.6
	is_attacking = true
	
func deal_damage() -> void:
	# Get all bodies overlapping with the sword hitbox
	# iterate through each unit from overlapping bodies to check if they are in the 'enemies' group
	# apply damage
	var bodies = torch_area.get_overlapping_bodies()
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
				enemy.damage(torch_damage)
			
func update_attack_cd(delta: float) -> void:
	# Timer for attack cooldown
	# Subtract time since last frame from attack cooldown until it's below 0, then update attacking status
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")
			
func update_blast(delta: float) -> void:
	# Timer for fart cooldown
	# Set blast cooldown to the exported blast_interval var
	blast_cooldown -= delta
	if blast_cooldown > 0: return
	blast_cooldown = blast_interval
	
	# Instantiate blast scene, set the damage amount, add as a child to the goblin
	var blast = blast_scene.instantiate()
	blast.damage_amount = blast_damage
	add_child(blast)
				
func hitbox_check(delta: float) -> void:
	# Time countdown for hitbox cd
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	# Hitbox cd
	hitbox_cooldown = 0.5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)
	
func damage(amount: int) -> void:
	if health <= 0: return
	
	# subtract amount param from health
	health -= amount

	# modulate and tween to make the sprite flash red
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# if health below 0, call die func
	if health <= 0:
		die()
		
func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Yum! Heal de ", amount, " . Vida: ", health, "/", max_health)
	return health

func die() -> void:
	# if death_prefab exists, make a new instance of death_prefab on the same position as enemy
	if death_prefab: 
		var death_obj = death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)
		
	# remove the enemy instance from the game
	print("Player morreu!")
	queue_free()

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
	# Play anim if it's not attacking so it's fixed to the direction of attack
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
