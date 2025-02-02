extends CharacterBody2D

@onready var detector: Area2D = $Detector

const DIRECTIONS = [Vector2(-32, 0), Vector2(32, 0), Vector2(0, -32), Vector2(0, 32)]

var ready_to_move: bool = false
var can_move: bool = false

func _ready() -> void:
	randomize_detector_position()
	detector.can_move.connect(set_ready_to_move)
	detector.change_position.connect(randomize_detector_position)

func _process(_delta: float) -> void:
	if can_move and ready_to_move:
		move()

func randomize_detector_position() -> void:
	detector.position = Vector2(0, 0)
	await get_tree().create_timer(.01).timeout
	detector.position = DIRECTIONS.pick_random()

func set_ready_to_move() -> void:
	ready_to_move = true

func move() -> void:
	if !ready_to_move or !can_move:
		return
	
	ready_to_move = false
	can_move = false
	var tween = create_tween()
	var target_position = self.position + detector.position
	tween.tween_property(self, "position", target_position, .5)
	randomize_detector_position()
