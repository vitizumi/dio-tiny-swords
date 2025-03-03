class_name Enemy
extends Node2D

@export var health: int = 10
@export var death_prefab: PackedScene

func damage(amount: int) -> void:
	# subtract amount param from health
	health -= amount

	# modulate and tween to make the enemy sprite flash red
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# if health below 0, call die func
	if health <= 0:
		die()

func die() -> void:
	# if death_prefab exists, make a new instance of death_prefab on the same position as enemy
	if death_prefab: 
		var death_obj = death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)
		
	# remove the enemy instance from the game
	queue_free()
