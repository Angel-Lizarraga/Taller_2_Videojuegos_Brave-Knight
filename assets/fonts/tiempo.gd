extends CanvasLayer

var timer_out = 150
@onready var timer = $Timer
@onready var label = $TimerGame

func _ready() -> void:
	timer.wait_time = 1.0
	timer.start()

func _on_timer_timeout() -> void:
	timer_out -= 1
	label.text = "Timer: " + str(timer_out)
	
	if timer_out <= 0:
		timer.stop()
