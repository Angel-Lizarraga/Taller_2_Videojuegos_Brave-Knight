extends BaseEnemy

var direction : Vector2 = Vector2.RIGHT
var home : Vector2
var previous_state : ENEMY_STATES
var gravity = 600
@onready var throwTimer : Timer = $ThrowTimer
@onready var marker_ref : Marker2D = $Marker2D

func _ready() -> void:
	super._ready()
	current_state = ENEMY_STATES.PATROL
	home = global_position
	hp = 3
	

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func _physics_process(delta: float) -> void:
	calculate_state()
	apply_gravity(delta)
	move_and_slide()
	
func calculate_state() -> void :
	match current_state:
		ENEMY_STATES.PATROL:
			pass
		ENEMY_STATES.FOLLOWING_PLAYER :
			if not patrol_timer.is_stopped() :
				patrol_timer.stop()
			var player_angle = abs(rad_to_deg(get_angle_to(player_ref.global_position)))
			if player_angle < 90 :
				anim_sprite2D.flip_h = false
			else :
				anim_sprite2D.flip_h = true
			if anim_sprite2D.flip_h :
				marker_ref.position.x = -26.0
			else :
				marker_ref.position.x = 26.0


func _on_patrol_timer_timeout() -> void:
	anim_sprite2D.flip_h = !anim_sprite2D.flip_h
	if anim_sprite2D.flip_h :
		marker_ref.position.x = -26.0
	else :
		marker_ref.position.x = 26.0


func _on_detection_area_entered(_area: Area2D) -> void:
	if(current_state != ENEMY_STATES.DEATH) :
		current_state = ENEMY_STATES.FOLLOWING_PLAYER
		anim_sprite2D.play("throw")


func _on_detection_area_exited(_area: Area2D) -> void:
	anim_sprite2D.play("idle");
	current_state = ENEMY_STATES.PATROL
	if patrol_timer.is_stopped() :
		patrol_timer.start()


func _on_animation_finished() -> void:
	if(anim_sprite2D.animation == "throw") : 
		ObjectMaker.create_bomb(anim_sprite2D.flip_h, player_ref.global_position, marker_ref.global_position)
		throwTimer.start()
	if(anim_sprite2D.animation == "death") :
		current_state = ENEMY_STATES.DEATH
		queue_free()


func _on_hitbox_area_entered(_area: Area2D) -> void:
	hp-= player_ref.strength
	set_deferred("monitoring", false)
	if hp<=0 :
		current_state = ENEMY_STATES.DEATH
		anim_sprite2D.play("death")
	else :
		previous_state = current_state
		current_state = ENEMY_STATES.HIT
		invincible_timer.start()
		print(hp)
		direction *= -1
		var tween = create_tween()
		tween.tween_property(anim_sprite2D,"self_modulate", Color(1,0,0,1),0.25)
		tween.tween_property(anim_sprite2D,"self_modulate", Color(1,1,1,1),0.25)
		tween.tween_property(anim_sprite2D,"self_modulate", Color(1,0,0,1),0.25)
		tween.tween_property(anim_sprite2D,"self_modulate", Color(1,1,1,1),0.25)


func _on_throw_timeout() -> void:
	anim_sprite2D.play("throw")
