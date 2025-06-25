extends BaseEnemy

var direction: Vector2 = Vector2.RIGHT
var initial_pos: Vector2
var previous_state : ENEMY_STATES

func _ready(): 
	super._ready()
	current_state = ENEMY_STATES.PATROL
	initial_pos = global_position
	hp = 3

func _physics_process(delta: float) -> void:
	match current_state: 
		ENEMY_STATES.RETURNING:
			nav_agent.target_position = initial_pos
			direction = to_local(nav_agent.get_next_path_position()).normalized()
			if(nav_agent.is_navigation_finished()):
				current_state = ENEMY_STATES.PATROL
				print("current enemy state ", current_state)
				direction = Vector2.RIGHT
		ENEMY_STATES.PATROL:
			if patrol_timer.is_stopped():
				patrol_timer.start()
		ENEMY_STATES.FOLLOWING_PLAYER:
			if not patrol_timer.is_stopped():
				patrol_timer.stop()
			nav_agent.target_position = player_ref.global_position
			direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * mov_speed * delta
	
	if velocity.x > 0:
		anim_sprite2D.flip_h = false 
	else:
		anim_sprite2D.flip_h = true
	
	move_and_slide()
	
func _on_patrol_timer_timeout() -> void:
	if direction ==  Vector2.RIGHT:
		direction = Vector2.LEFT
		anim_sprite2D.flip_h = true
	else:
		direction = Vector2.RIGHT
		anim_sprite2D.flip_h = false

func _on_detection_area_entered(_area: Area2D) -> void:
	if current_state != ENEMY_STATES.DEATH:
		if (player_ref.is_alive):
			current_state = ENEMY_STATES.FOLLOWING_PLAYER
		else:
			current_state = ENEMY_STATES.RETURNING
		print("current enemy state ", current_state)


func _on_detection_area_exited(_area: Area2D) -> void:
	current_state = ENEMY_STATES.RETURNING
	print("current enemy state ", current_state)


func _on_hitbox_area_entered(_area: Area2D) -> void:
	hp -= player_ref.strength
	hitbox.monitorable = false
	if hp <= 0 :
		current_state = ENEMY_STATES.DEATH
		anim_sprite2D.play("death")
		velocity = Vector2.ZERO
		hitbox.monitorable = false
	else:
		previous_state = current_state
		current_state = ENEMY_STATES.HIT
		direction *= -1
		print(hp)
		invincible_timer.start()
		var tween = create_tween()
		tween.tween_property(anim_sprite2D, "self_modulate", Color(1,0,0,1), 0.25)
		tween.tween_property(anim_sprite2D, "self_modulate", Color(1,1,1,1), 0.25)
		tween.tween_property(anim_sprite2D, "self_modulate", Color(1,0,0,1), 0.25)
		tween.tween_property(anim_sprite2D, "self_modulate", Color(1,1,1,1), 0.25)

func _on_invincible_timer_timeout() -> void:
	current_state = previous_state
	hitbox.monitoring = true
	


func _on_animation_finished() -> void:
	if anim_sprite2D.animation == "death":
		queue_free()
