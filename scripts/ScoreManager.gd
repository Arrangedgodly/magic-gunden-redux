extends Node2D
signal end_score(final_score: int, final_enemies_killed: int, final_gems_collected: int)

@onready var player: CharacterBody2D = %Player
@onready var gem_manager: Node2D = %GemManager

var score: int = 0
var enemies_killed: int = 0
var gems_collected: int = 0

func _ready() -> void:
	player.game_end.connect(end_game)
	gem_manager.gems_scored.connect(_on_gems_scored)

func _on_enemy_killed() -> void:
	enemies_killed += 1

func _on_gem_collected() -> void:
	gems_collected += 1

func _on_gems_scored(gem_count: int) -> void:
	var multiplier = 1
	while gem_count > 0:
		score += 100 * multiplier
		multiplier += 1
		gems_collected += 1
		gem_count -= 1

func end_game() -> void:
	end_score.emit(score, enemies_killed, gems_collected)
