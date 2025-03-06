extends Node

signal game_over

var player_position: Vector2
var goblin: Goblin
var is_gameover: bool = false
var time_elapsed: float = 0.0
var time_elapsed_str: String
var meat_counter: int = 0
var monsters_defeated_counter: int = 0

func _process(delta: float) -> void:
	time_elapsed += delta
	var time_elapsed_sec:int = floori(time_elapsed)
	var seconds: int = time_elapsed_sec % 60
	var minutes: int = time_elapsed_sec / 60
	# %02d format to pass a num, in brackets the vars passed to it
	time_elapsed_str = "%02d:%02d" % [minutes, seconds]
	
func end_game() -> void:
	if is_gameover: return
	is_gameover = true
	game_over.emit()

func reset() -> void:
	goblin = null
	player_position = Vector2.ZERO
	is_gameover = false
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
	time_elapsed = 0.0
	time_elapsed_str = "00:00"
	meat_counter = 0
	monsters_defeated_counter = 0
