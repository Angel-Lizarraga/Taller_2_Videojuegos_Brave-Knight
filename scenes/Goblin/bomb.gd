extends RigidBody2D

func _ready() -> void:
	set_lock_rotation_enabled(true)

func setup_bomb(playerPos : Vector2) -> void :
	apply_impulse(to_local(playerPos))
