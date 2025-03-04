extends Node2D


@export var creatures: Array[PackedScene]
@export var mobs_per_min: float = 60.0

@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

var cooldown: float = 0.0

func _process(delta: float) -> void:
	# Timer countdown for new unit
	cooldown -= delta
	if cooldown > 0: return
	
	# frequency of mobs per min (e.g. 60 sec / 60 mobs per minute = 1 mob per sec)
	var interval = 60.0 / mobs_per_min
	cooldown = interval
	
	# get random unit inside the array of enemies, set it to a var. and instantiate it
	# uses global_position 
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = get_point()
	get_parent().add_child(creature)

func get_point() -> Vector2:
	# get a random float value between 0 to 1 to determine a point in the PathFollow2D to spawn an enemy
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
