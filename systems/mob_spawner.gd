extends Node2D

@export var creatures: Array[PackedScene]
@onready var path_follow_2d: PathFollow2D = %PathFollow2D

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.position
