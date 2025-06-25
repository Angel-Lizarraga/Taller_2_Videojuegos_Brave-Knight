extends CanvasLayer

@onready var anim_player = $AnimationPlayer
@onready var continue_label = $MarginContainer/VBoxContainer/ContinueLabel
var can_press_space = false

func _ready() -> void:
	visible = false
	SignalManager.on_player_death.connect(on_player_death)
	continue_label.visible = false


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("jump") and can_press_space):
		print("Starting game again")
		can_press_space = false
		get_tree().paused = false
		GameManager.on_return_to_menu()

func on_player_death(state:int):
	get_tree().paused = true
	visible = true
	
	if state == 0 :
		anim_player.play("game_over_apear") 
	else :
		anim_player.play("win_apear")
	continue_label.visible = true
	anim_player.queue("modulate_continue")
	can_press_space = true
