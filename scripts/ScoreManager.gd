extends Node2D
signal end_score(final_score: int, final_enemies_killed: int, final_gems_collected: int)

@onready var player: CharacterBody2D = %Player
@onready var gem_manager: Node2D = %GemManager
@onready var score_label: Label = $CanvasLayer/Control/ScoreLabel
@onready var score_timer: Timer = $ScoreTimer

var score: int = 0
var enemies_killed: int = 0
var gems_collected: int = 0

func _ready() -> void:
	player.game_end.connect(end_game)
	gem_manager.gems_scored.connect(_on_gems_scored)
	_update_score_label(0, .01)

func _on_enemy_killed() -> void:
	enemies_killed += 1

func _on_gem_collected() -> void:
	gems_collected += 1

func _on_gems_scored(gem_count: int) -> void:
	var multiplier = 1
	while gem_count > 0:
		score += 100 * multiplier
		_update_score_label(score, 1)
		multiplier += 1
		gems_collected += 1
		gem_count -= 1

func end_game() -> void:
	end_score.emit(score, enemies_killed, gems_collected)

func _update_score_label(target_score: int, duration: float) -> void:
	var start_score = score
	var score_difference = target_score - start_score
	var steps = 10
	var step_duration = duration / steps
	
	for i in range(steps):
		@warning_ignore("integer_division")
		var current_score = start_score + (score_difference * (i + 1) / steps)
		var formatted_score = str(round(current_score)).pad_zeros(5)
		score_label.text = formatted_score
		score_timer.wait_time = step_duration
		score_timer.start()
		await score_timer.timeout
	
	score_label.text = str(score).pad_zeros(5)
