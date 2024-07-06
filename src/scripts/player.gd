extends StaticBody2D

const velocity = 100
var player_name = ""

func _ready():
	player_name = get_meta("player_name")

func _physics_process(delta):
	var direction = 0
	if player_name == "player1":
		if Input.is_key_pressed(KEY_W):
			direction = -1
		if Input.is_key_pressed(KEY_S):
			direction = 1
	elif player_name == "player2":
		direction = Input.get_axis("ui_up", "ui_down")
		
	move_and_collide(Vector2(0, direction* velocity * delta))
