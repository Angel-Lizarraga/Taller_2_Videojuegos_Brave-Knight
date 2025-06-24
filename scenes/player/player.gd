extends CharacterBody2D

class_name Player
@onready var anim_sprite2D = $AnimatedSprite2D
@onready var floor_detector = $FloorDetector
@onready var floor_detector2 = $FloorContact

enum PLAYER_STATE {IDLE, RUN, ATTACK, JUMP, HIT, FALL, DEATH}

@export var movement_speed = 10000.0
@export var jump_speed = 40000.0
@export var gravity = 500.0


var current_state : PLAYER_STATE = PLAYER_STATE.IDLE

var is_grounded = false
var is_attacking = false
@onready var attack_area : Area2D = $attack_hitbox
@onready var attack_collision : CollisionShape2D = $%collision_hitbox
@onready var invencible_timer : Timer = $Invincible

var direction :  Vector2
var hit_speed : float = 10000
var strength : int = 1

func _physics_process(delta: float) -> void:
	get_input(delta)
	if not is_attacking:
		if current_state != PLAYER_STATE.HIT:
			calculate_state()
		else:
			velocity = direction * hit_speed * delta
	check_is_on_ground()
	apply_gravity(delta)
	move_and_slide()
	
func check_is_on_ground():
	if floor_detector.is_colliding():
		is_grounded = true
	else:
		is_grounded = false
	
func get_input(delta):
	if current_state == PLAYER_STATE.HIT:
		return
	if(Input.is_action_pressed("move_left")):
		if Input.is_action_pressed("run"):
			anim_sprite2D.speed_scale = 1.5
			velocity.x = -movement_speed * delta * 1.5
		else:	
			anim_sprite2D.speed_scale = 1
			velocity.x = -movement_speed * delta
		if not anim_sprite2D.flip_h:
			flip_player()
	elif(Input.is_action_pressed("move_right")):
		if Input.is_action_pressed("run"):
			anim_sprite2D.speed_scale = 1.5
			velocity.x = movement_speed * delta * 1.5
		else:
			anim_sprite2D.speed_scale = 1
			velocity.x = movement_speed * delta
		if    anim_sprite2D.flip_h:
			flip_player()
	else:
		velocity.x = 0
	if Input.is_action_just_released("jump"):
		if velocity.y <= 0 :
			velocity.y = 0
	
	if(Input.is_action_just_pressed("jump")and is_grounded ):
		velocity.y = -jump_speed * delta 
	
	if(Input.is_action_just_pressed("attack") and not is_attacking):
		attack()

		
func  calculate_state():
		if(is_grounded):
			if abs(velocity.x) > 0:
				set_state(PLAYER_STATE.RUN)
			else:
				set_state(PLAYER_STATE.IDLE)
		else:
			if velocity.y < 0:
				set_state(PLAYER_STATE.JUMP)
			else:
				set_state(PLAYER_STATE.FALL)

func  set_state(new_state: PLAYER_STATE):
	if (new_state != current_state):
		current_state = new_state
		match current_state:
			PLAYER_STATE.RUN:
				anim_sprite2D.play("run")
			PLAYER_STATE.IDLE:
				anim_sprite2D.play("idle")
			PLAYER_STATE.JUMP:
				anim_sprite2D.play("jump")
			PLAYER_STATE.FALL:
				anim_sprite2D.play("fall")
			PLAYER_STATE.ATTACK:
				anim_sprite2D.play("attack")
			PLAYER_STATE.HIT:
				anim_sprite2D.play("hit")

				
func apply_gravity(delta):
	velocity.y += gravity * delta


func _on_animated_sprite_2d_animation_finished() -> void:
	if(anim_sprite2D.animation == "attack"):
		reset_states()
		
func attack():
		is_attacking = true
		attack_area.monitorable = true
		attack_area.monitoring = true		
		set_state(PLAYER_STATE.ATTACK)
		attack_area.visible = true
		
func flip_player():
	anim_sprite2D.flip_h = not anim_sprite2D.flip_h
	attack_collision.position.x *= -1


func _on_hitbox_area_entered(area: Area2D) -> void:
	if (area.get_parent().get_class() == "RigidBody2D"):
		#direction = area.get_parent().linear_velocity.normalized()
		pass
	elif (area.get_parent().get_class() == "CharacterBody2D"):
		direction = area.get_parent().velocity.normalized()
	set_state(PLAYER_STATE.HIT)
	invencible_timer.start()
	var tween = create_tween()
	tween.tween_property(anim_sprite2D, "self_modulate", Color(1,1,1,0), 0.25)
	tween.tween_property(anim_sprite2D, "self_modulate", Color(1,1,1,1), 0.25)
	tween.tween_property(anim_sprite2D, "self_modulate", Color(1,1,1,0), 0.25)
	tween.tween_property(anim_sprite2D, "self_modulate", Color(1,1,1,1), 0.25)
	tween.tween_property(anim_sprite2D, "self_modulate", Color(1,1,1,0), 0.25)
	tween.tween_property(anim_sprite2D, "self_modulate", Color(1,1,1,1), 0.25)
	print("te estan golpeando")


func _on_invincible_timeout() -> void:
	reset_states()

func reset_states():
	set_state(PLAYER_STATE.IDLE)
	is_attacking = false
	attack_area.visible = false
	attack_area.monitorable = false
	attack_area.monitoring = false
	
