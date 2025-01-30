extends CanvasLayer

@onready var score: Label = $VBoxContainer/FinalScore
@onready var gems_collected: Label = $VBoxContainer/GemsCollected
@onready var enemies_killed: Label = $VBoxContainer/EnemiesKilled
@onready var score_manager: Node2D = %ScoreManager

func _ready() -> void:
	hide()
	score_manager.end_score.connect(_on_game_end)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_game_end(final_score: int, final_enemies_killed: int, final_gems_collected: int) -> void:
	get_tree().paused = true
	score.text = "Final Score: " + str(final_score)
	enemies_killed.text = "Enemies Killed: " + str(final_enemies_killed)
	gems_collected.text = "Gems Collected: " + str(final_gems_collected)
	show()

func _on_try_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
