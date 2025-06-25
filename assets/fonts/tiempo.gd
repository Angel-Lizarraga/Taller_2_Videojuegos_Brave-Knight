extends CanvasLayer

var timer_out = 60
@onready var timer = $Timer
@onready var timer_label = $TimerGame
@onready var lives_label = $LivesLabel

func _ready() -> void:
	timer.wait_time = 1.0
	timer.start()
	SignalManager.on_player_hit.connect(on_player_hit)
	timer_label.text = "Timer: " + str(timer_out)

func _on_timer_timeout() -> void:
	timer_out -= 1
	timer_label.text = "Timer: " + str(timer_out)
	
	if timer_out <= 0:
		print("Tiempo fuera")
		timer.stop()
		SignalManager.on_player_death.emit(0)

func on_player_hit(lives: int):
	lives_label.text = "Lives: " + str(lives)
