extends Node2D

@onready var timer : = get_node("Timer")
@onready var ball : = get_node("/root/Level1/Ball")
var timerTimeouts = 3


func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _on_ball_game_reset():
	$TimerLabel.text = str(timerTimeouts)
	$TimerLabel.visible = true
	timer.start()

func _on_timer_timeout():
	timerTimeouts -= 1
	$TimerLabel.text = str(timerTimeouts)
	if timerTimeouts == 0:
		$TimerLabel.visible = false
		timerTimeouts = 3;
		timer.stop()
		ball.start_ball()
