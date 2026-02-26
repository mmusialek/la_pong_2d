extends Node2D

@onready var timer : = get_node("Timer")
@onready var ball : = get_node("/root/Level1/Ball")
var timerTimeouts = 3


func _ready():
	timer.timeout.connect(_on_timer_timeout)
	# when the level is first loaded we want the countdown to run
	# the ball hasn't emitted game_reset yet, so trigger it manually
	_on_ball_game_reset()

func _on_ball_game_reset():
	# make sure the ball is in its reset/hidden state before the countdown
	if ball.has_method("__reset"):
		ball.__reset()

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
