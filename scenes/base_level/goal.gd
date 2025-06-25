extends Area2D



func _on_area_entered(area: Area2D) -> void:
	SignalManager.on_player_death.emit(1)
