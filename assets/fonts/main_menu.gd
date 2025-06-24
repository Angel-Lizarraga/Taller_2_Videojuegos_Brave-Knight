extends MarginContainer

func _on_start_button_button_down() -> void:
	ObjectMaker.on_game_start()
	
func _on_exit_button_2_button_down() -> void:
	ObjectMaker.on_exit()
