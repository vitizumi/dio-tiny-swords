extends Node

# On ready vars
#@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
# Export vars -> can edit on Inspector
@export var speed = 1.0
# Character vars
var enemy: Enemy # Declare var of the same type as the parent Pawn node (class_name)
var sprite: AnimatedSprite2D

func _ready() -> void:
	# Use get_parent to access the Pawn node and set it to enemy
	enemy = get_parent()
	# Use get_node to get the child node named AnimatedSprite2D of enemy (meaning, the Pawn node) so we can flip it
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta: float) -> void:
	# Set the player_pos (the target movement location) to the one grabbed from the autoloaded script GameManager
	# Use it to calculate the target vector
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	enemy.velocity = input_vector * speed * 100
	enemy.move_and_slide()
	
	# Flip sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
