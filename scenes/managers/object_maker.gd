extends Node

@export var bomb = preload("res://Scenes/Goblin/bomb.tscn")

func create_bomb(isFlipped : bool, playerPos : Vector2, markerPos : Vector2) -> void :
	var new_bomb = bomb.instantiate()
	new_bomb.global_position = markerPos
	get_tree().get_current_scene().add_child(new_bomb)
	new_bomb.setup_bomb(playerPos, isFlipped)
	new_bomb.start_timer()
