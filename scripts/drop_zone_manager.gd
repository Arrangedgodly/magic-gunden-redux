extends Node2D

var pattern_bar: bool = true
var bars_vertical: bool = false
var tile_size: int = 32

@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = %Player

const DROP_ZONE = preload("res://scenes/drop_zone.tscn")

func _ready() -> void:
	player.game_start.connect(_on_player_game_start)
	timer.timeout.connect(_on_timer_timeout)

func _on_player_game_start() -> void:
	timer.start()
	
	_on_timer_timeout()
	
func spawn_capture_points(starting_pos):
	if pattern_bar:
		pattern_bar = false
		for i in range(12):
			var capture_point_instance = DROP_ZONE.instantiate()
			capture_point_instance.position = starting_pos
			capture_point_instance.position += Vector2.DOWN * 16
			capture_point_instance.position += Vector2.RIGHT * 16
			if not bars_vertical:
				capture_point_instance.position.x += i * tile_size
			else:
				capture_point_instance.position.y += i * tile_size
			add_child(capture_point_instance)
	else:
		pattern_bar = true
		for i in range(16):
			var capture_point_instance = DROP_ZONE.instantiate()
			capture_point_instance.position = starting_pos
			capture_point_instance.position += Vector2.DOWN * 16
			capture_point_instance.position += Vector2.RIGHT * 16
			
			@warning_ignore("integer_division")
			var row = i / 4
			var col = i % 4
			
			capture_point_instance.position.x += col * tile_size
			capture_point_instance.position.y += row * tile_size
			
			if row == 0 and (col == 1 or col == 2):
				add_child(capture_point_instance)
			elif row == 1 or row == 2:
				add_child(capture_point_instance)
			elif row == 3 and (col == 1 or col == 2):
				add_child(capture_point_instance)
	
	timer.start()

func find_capture_spawn_point():
	var x = 0
	var y = 0
	randomize()
	if pattern_bar:
		if bars_vertical:
			y = (randi_range(0, 11) * 32)
			bars_vertical = false
		else:
			x = (randi_range(0, 11) * 32)
			bars_vertical = true
	else:
		y = (randi_range(1, 7) * 32)
		x = (randi_range(1, 7) * 32)
	
	return Vector2i(x,y)

func clear_capture_points():
	var capture_points = get_tree().get_nodes_in_group("capture")
	for point in capture_points:
		point.queue_free()

func _on_timer_timeout() -> void:
	clear_capture_points()
	var spawn_point = find_capture_spawn_point()
	spawn_capture_points(spawn_point)
