extends Node

@export var speed = 1.0
#@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D    igual func _ready()

var sprite: AnimatedSprite2D
var enemy: Enemy 

func _ready() -> void:
	enemy = get_parent()
	sprite = enemy.get_node("AnimationSprite")

func _physics_process(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	enemy.velocity = input_vector * speed * 100
	enemy.move_and_slide()
	
	#Flip sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
