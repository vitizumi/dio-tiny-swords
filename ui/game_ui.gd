extends CanvasLayer

@onready var timer_label: Label = $TimerLabel
#@onready var gold_label: Label = $GoldLabel
@onready var meat_label: Label = $Panel/MeatLabel

func _process(delta: float) -> void:
	timer_label.text = GameManager.time_elapsed_str
	meat_label.text = str(GameManager.meat_counter)
