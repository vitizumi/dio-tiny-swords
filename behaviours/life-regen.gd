extends Node2D

@export var regen_amt: int = 10

func _ready() -> void:
	$Area2D.body_entered.connect(on_body_entered)
	
func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var goblin: Goblin = body
		goblin.heal(regen_amt)
		queue_free()
