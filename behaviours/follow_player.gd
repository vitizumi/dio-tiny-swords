extends CharacterBody2D

# On ready vars
# @onready var sprite:AnimatedSprite2D = $AnimatedSprite2D    igual func _ready()
# Export vars -> can edit on Inspector
@export var speed = 1.0
# Character vars
var sprite: AnimatedSprite2D
#var enemy: Enemy 

func _ready() -> void:
	#enemy = get_parent()
	#sprite = enemy.get_node("AnimationSprite")
	pass

func _physics_process(delta: float) -> void:
	#var player_position = GameManager.player_position
	var player_position = Vector2(0,0)
	var difference = player_position - position
	var input_vector = difference.normalized()
	velocity = input_vector * speed * 100
	move_and_slide()
	
	##Flip sprite
	#if input_vector.x > 0:
		#sprite.flip_h = false
	#elif input_vector.x < 0:
		#sprite.flip_h = true
