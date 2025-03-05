extends CanvasLayer

@onready var timer_label: Label = $TimerLabel
#@onready var gold_label: Label = $GoldLabel
@onready var meat_label: Label = $Panel/MeatLabel
var time_elapsed: float = 0.0
var meat_counter: int = 0

func _ready() -> void:
	GameManager.goblin.meat_collected.connect(on_meat_collected)
	meat_label.text = str(meat_counter)

func _process(delta: float) -> void:
	time_elapsed += delta
	var time_elapsed_sec:int = floori(time_elapsed)
	var seconds: int = time_elapsed_sec % 60
	var minutes: int = time_elapsed_sec / 60
	# %02d format to pass a num, in brackets the vars passed to it
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	pass

func on_meat_collected(regen_value:int) -> void:
	meat_counter += 1
	meat_label.text = str(meat_counter)
