extends Node2D

var player1_score = 0
var player2_score = 0

func _ready():
	update_scoreboard()

func update_scoreboard():
	$Player1Score.text = str(player1_score)
	$Player2Score.text = str(player2_score)

func _on_ball_player_scored(player_name):
	if player_name == "player1":
		player1_score += 1
	elif  player_name == "player2":
		player2_score += 1

	update_scoreboard()
