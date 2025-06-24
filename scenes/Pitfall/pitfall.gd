extends Node2D

@onready var area2d : Area2D
@onready var player_ref : Player
@export var respawnPoint : Marker2D #Assigned in level

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("AAAAAAAAAAAAAAAAAAAAAAAAAAA")
	area.get_parent().global_position = respawnPoint.global_position
	
