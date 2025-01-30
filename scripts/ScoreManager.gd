extends Node2D
signal end_score(final_score: int, final_enemies_killed: int, final_gems_collected: int)

@onready var player: CharacterBody2D = %Player

var score: int = 0
var enemies_killed: int = 0
var gems_collected: int = 0

func _ready() -> void:
	player.game_end.connect(end_game)

func _on_enemy_killed() -> void:
	enemies_killed += 1

func _on_gem_collected() -> void:
	gems_collected += 1

func end_game() -> void:
	end_score.emit(score, enemies_killed, gems_collected)
