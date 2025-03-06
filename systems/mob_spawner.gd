class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]

@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

var mobs_per_min: float = 60.0
var cooldown: float = 0.0

func _process(delta: float) -> void:
	# Ignore if gameover
	if GameManager.is_gameover: return
	
	# Timer countdown for new unit
	cooldown -= delta
	if cooldown > 0: return
	
	# frequency of mobs per min (e.g. 60 sec / 60 mobs per minute = 1 mob per sec)
	var interval = 60.0 / mobs_per_min
	cooldown = interval
	
	# check if spawn location is valid
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var result: Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return
	
	# get random unit inside the array of enemies, set it to a var. and instantiate it
	# uses global_position 
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)

func get_point() -> Vector2:
	# get a random float value between 0 to 1 to determine a point in the PathFollow2D to spawn an enemy
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
