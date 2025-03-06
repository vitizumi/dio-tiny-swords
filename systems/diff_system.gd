extends Node

@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 60.0
@export var spawns_minute: int = 30
@export var wave_duration: float = 20
@export var break_intensity: float = 0.5

var time: float = 0.0

func _process(delta: float) -> void:
	# Ignore if gameover
	if GameManager.is_gameover: return
	
	time += delta
	
	var spawn_rate = initial_spawn_rate + spawns_minute * time / 60.0
	
	var sinwave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sinwave, -1.0, 1.0, break_intensity, 1)
	
	spawn_rate *= wave_factor
	mob_spawner.mobs_per_min = spawn_rate
	
