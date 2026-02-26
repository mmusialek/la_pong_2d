extends RigidBody2D

# signals
signal player_scored(player_name: String)
signal game_reset()
signal bounced(intensity: float)

# ball config
const BASE_SPEED: float = 100.0
var current_speed: float = BASE_SPEED
const MAX_SPEED: float = 300.0
const SPEED_MULTIPLIER: float = 1.05
var rotation_speed: float = 0.0
const MAX_ROTATION_SPEED: float = PI * 4.0
const ROTATION_DAMPING: float = 0.5
const WALL_ROTATION_FACTOR: float = 15.0
var velocity = Vector2.ZERO
const MAX_BOUNCE_ANGLE = PI / 4.0 # 45 degrees
const SparkEffect = preload("res://scenes/packages/spark_effect.tscn")

# trail
@onready var trail: Line2D = $Trail
const MAX_TRAIL_LENGTH: int = 15

 #audio
var player: AudioStreamPlayer
var ball_bounce
var paddle_bounce
var player_scored_sound

func _ready():
	# initial random velocity direction, will be overwritten by __reset()
	velocity.x = [-1,1][randi()%2]
	velocity.y = [-0.8,0.8][randi()%2]
	player = AudioStreamPlayer.new()
	add_child(player)

	ball_bounce = preload("res://assets/audio/ball_bounce.wav")
	paddle_bounce = preload("res://assets/audio/paddle_bounce.wav")
	player_scored_sound = preload("res://assets/audio/player_scored.wav")

	var curve = Curve.new()
	curve.add_point(Vector2(0, 0))
	curve.add_point(Vector2(1, 1))
	trail.width_curve = curve

	# make sure the ball starts in the reset (hidden, stopped) state
	__reset()

func _physics_process(delta):
	var new_velo = velocity * current_speed * delta
	var collision = move_and_collide(new_velo)
	rotate(rotation_speed * delta)
	rotation_speed = lerp(rotation_speed, 0.0, delta * ROTATION_DAMPING)
	
	trail.add_point(global_position)
	if trail.get_point_count() > MAX_TRAIL_LENGTH:
		trail.remove_point(0)

	if collision:
		var spark = SparkEffect.instantiate()
		get_tree().current_scene.add_child(spark)
		spark.global_position = collision.get_position()
		spark.rotation = collision.get_normal().angle()

		var collider = collision.get_collider()
		if collider.name == "WordBoundaries":
			play_ball_bounce()
			bounced.emit(2.0)
			# Change rotation direction and speed based on realistic physics
			rotation_speed += velocity.x * collision.get_normal().y * WALL_ROTATION_FACTOR

		if collider.name in ["player1", "player2"]:
			play_paddle_bounce()
			bounced.emit(4.0)
			
			# increase speed after paddle hit
			current_speed = min(current_speed * SPEED_MULTIPLIER, MAX_SPEED)
			
			# Calculate relative intersection y
			var relative_y = collision.get_position().y - collider.position.y
			
			# Normalize relative y (paddle height is 16, half is 8)
			var normalized_y = clamp(relative_y / 8.0, -1.0, 1.0)
			
			# Calculate bounce angle
			var bounce_angle = normalized_y * MAX_BOUNCE_ANGLE
			
			# Determine x direction based on which player was hit
			var dir_x = 1 if collider.name == "player1" else -1
			
			# Set new velocity
			velocity = Vector2(dir_x * cos(bounce_angle), sin(bounce_angle)).normalized()
			
			# Set rotation speed based on where it hit the paddle
			rotation_speed = normalized_y * MAX_ROTATION_SPEED
		else:
			velocity = velocity.bounce(collision.get_normal())
			# Apply rotation effect to bounce trajectory
			velocity.x += rotation_speed * 0.05 * collision.get_normal().y
			velocity = velocity.normalized()


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

func start_ball():
	show()
	set_physics_process(true)
	set_process(true)

func __reset():
	hide()
	# trail may not be initialized if this is called before _ready
	if trail:
		trail.clear_points()
	set_physics_process(false)
	set_process(false)
	rotation_speed = 0.0
	current_speed = BASE_SPEED
	velocity.x = [-1,1][randi()%2]
	velocity.y = [-0.8,0.8][randi()%2]
	position = Vector2.ZERO
	move_and_collide(velocity)

func killozne_entered(player_name: String):
	play_player_scored_sound()
	__reset()
	player_scored.emit(player_name)
	game_reset.emit()

func play_ball_bounce():
	player.stream = ball_bounce
	player.play()

func play_paddle_bounce():
	player.stream = paddle_bounce
	player.play()

func play_player_scored_sound():
	player.stream = player_scored_sound
	player.play()
