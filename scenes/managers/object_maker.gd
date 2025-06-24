extends Node

@export var bomb = preload("res://Scenes/Goblin/bomb.tscn")
var game_scene = preload("res://scenes/base_level/base_level.tscn")
var menu_scene = preload("res://assets/fonts/main_menu.gd")

func create_bomb(isFlipped : bool, playerPos : Vector2, markerPos : Vector2) -> void :
	var new_bomb = bomb.instantiate()
	new_bomb.global_position = markerPos
	get_tree().get_current_scene().add_child(new_bomb)
	new_bomb.setup_bomb(playerPos, isFlipped)
	new_bomb.start_timer()

func on_game_start():
	get_tree().change_scene_to_packed(game_scene)

func on_return_to_menu():
	get_tree().change_scene_to_packed(menu_scene)
	
func on_exit():
	get_tree().quit()
