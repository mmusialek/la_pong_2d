extends StaticBody2D

@onready var ball : = get_node("/root/Level1/Ball")

# player config
const velocity = 100
var player_name = ""

# cpu config
var cpu_move_timer: Timer
var prev_ball_pos = Vector2.ZERO;
var cpu_handicap = 0;
const cpu_experience_level = 8

# audio
var audio_player: AudioStreamPlayer
var paddle_bounce

func randomIntInRange(min_value: int, max_value: int) -> int:
	return randi() % (max_value - min_value + 1) + min_value

func _ready():
	cpu_move_timer = Timer.new()
	add_child(cpu_move_timer)
	cpu_move_timer.wait_time = .300
	cpu_move_timer.connect("timeout", _on_timer_timeout, 1)
	cpu_move_timer.start()

	player_name = get_meta("player_name")
	
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	paddle_bounce = preload("res://assets/audio/paddle_bounce.wav")

func _physics_process(delta):

	if player_name == "player1":
		var pos_delta = abs(position - prev_ball_pos)
		var towards_me = (position.x - prev_ball_pos.x) < (position.x - ball.position.x)
		if pos_delta.x < 170 and towards_me and cpu_handicap <= cpu_experience_level:
			var direction = 1 if ball.position.y>position.y else -1
			move_and_collide(Vector2(0, direction * velocity * delta))

	elif player_name == "player2":
		var direction = Input.get_axis("ui_up", "ui_down")
		move_and_collide(Vector2(0, direction* velocity * delta))
			
	prev_ball_pos = ball.position

func _on_timer_timeout():
	cpu_handicap = randomIntInRange(0,10)


func play_paddle_bounce():
	audio_player.stream = paddle_bounce
	audio_player.play()
