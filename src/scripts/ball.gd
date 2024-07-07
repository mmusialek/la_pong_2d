extends RigidBody2D

# signals
signal player_scored(player_name: String)
signal game_reset()

# ball config
const speed = 100
var velocity = Vector2.ZERO
var game_over = false

 #audio
var player: AudioStreamPlayer
var ball_bounce
var paddle_bounce
var player_scored_sound

func _ready():
	velocity.x = [-1,1][randi()%2]
	velocity.y = [-0.8,0.8][randi()%2]
	player = AudioStreamPlayer.new()
	add_child(player)

	ball_bounce = preload("res://assets/audio/ball_bounce.wav")
	paddle_bounce = preload("res://assets/audio/paddle_bounce.wav")
	player_scored_sound = preload("res://assets/audio/player_scored.wav")

func _physics_process(delta):
	if game_over:
		position = Vector2.ZERO
		velocity = Vector2.ZERO
		move_and_collide(velocity)
		return

	var new_velo = velocity * speed * delta
	var collision = move_and_collide(new_velo)
	rotate(PI*delta)
	if collision:
		var collider = collision.get_collider()
		if collider.name == "WordBoundaries":
			play_ball_bounce()

		if collider.name in ["player1", "player2"]:
			play_paddle_bounce()
		velocity = velocity.bounce(collision.get_normal())


func start_ball():
	game_over = false
	visible = true
	velocity.x = [-1,1][randi()%2]
	velocity.y = [-0.8,0.8][randi()%2]

func __reset():
	visible = false

func _on_left_killzone_body_entered(body):
	if body.name != "Ball":
		return

	killozne_entered("player2")

func _on_right_killzone_body_entered(body):
	if body.name != "Ball":
		return
		
	killozne_entered("player1")


#
# my
#

func killozne_entered(player_name: String):
	play_player_scored_sound()
	game_over = true
	__reset()
	player_scored.emit(player_name)
	game_reset.emit()
	__reset()

func play_ball_bounce():
	player.stream = ball_bounce
	player.play()

func play_paddle_bounce():
	player.stream = paddle_bounce
	player.play()

func play_player_scored_sound():
	player.stream = player_scored_sound
	player.play()
