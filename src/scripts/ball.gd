extends RigidBody2D

signal player_scored(player_name: String)
signal game_reset()

const speed = 100
var velocity = Vector2.ZERO
var game_over = false

func _ready():
	velocity.x = [-1,1][randi()%2]
	velocity.y = [-0.8,0.8][randi()%2]

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
		#print(collision.get_collider().name)
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

	game_over = true
	__reset()
	player_scored.emit("player2")
	game_reset.emit()

func _on_right_killzone_body_entered(body):
	if body.name != "Ball":
		return

	game_over = true
	__reset()
	player_scored.emit("player1")
	game_reset.emit()
	__reset()
