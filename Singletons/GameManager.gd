extends Node

var game_scene = preload("res://scenes/base_level/base_level.tscn")
var menu_scene = preload("res://assets/fonts/main_menu.tscn")

func _init() -> void:
	pass


func on_game_start():
	get_tree().change_scene_to_packed(game_scene)


func on_return_to_menu():
	print("regreso al menu")
	get_tree().change_scene_to_packed(menu_scene)


func on_exit():
	get_tree().quit()
