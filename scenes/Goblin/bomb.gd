extends RigidBody2D

@onready var animTimer1 : Timer = $animTimer1
@onready var animTimer2 : Timer = $animTimer2
@onready var animSprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox : Area2D = $hitbox

func _ready() -> void:
	set_lock_rotation_enabled(true)

func setup_bomb(playerPos : Vector2, isFlipped: bool) -> void :
	animSprite.flip_h = isFlipped
	apply_impulse(to_local(playerPos))
	hitbox.visible = false
	hitbox.monitorable = false

func start_timer() -> void :
	animTimer1.start()

func _on_anim_timer_1_timeout() -> void:
	animSprite.play("pre_explode")
	animTimer2.start()
	


func _on_anim_timer_2_timeout() -> void:
	animSprite.play("explosion")
	hitbox.visible = true
	hitbox.monitorable = true
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if animSprite.animation == "explosion" :
		queue_free()
