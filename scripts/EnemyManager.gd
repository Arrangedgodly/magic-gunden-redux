extends Node2D

@onready var spawn: Timer = $Spawn
@onready var move: Timer = $Move
@onready var map: Node2D = %Map
@onready var enemies: Node2D = %Enemies
@onready var player: CharacterBody2D = %Player
@onready var gem_manager: Node2D = %GemManager

const ENEMY = preload("res://scenes/enemy.tscn")

var can_move: bool = false

func _ready() -> void:
	spawn.timeout.connect(_on_spawn_timeout)
	move.timeout.connect(_on_move_timeout)
	player.game_start.connect(_start_timers)
	gem_manager.gems_converted.connect(_on_gems_converted)
	
	spawn_enemy(get_random_spawn_location())

func _process(delta: float) -> void:
	if can_move:
		if move_enemies():
			can_move = false
		
func get_random_spawn_location() -> Vector2:
	var spawn_tile = map.choose_spawn_location()
	return spawn_tile.position

func spawn_enemy(new_position: Vector2) -> void:
	var enemy_scene = ENEMY.instantiate()
	enemies.add_child(enemy_scene)
	enemy_scene.position = new_position

func _on_spawn_timeout() -> void:
	spawn_enemy(get_random_spawn_location())

func _on_move_timeout() -> void:
	can_move = true

func move_enemies() -> bool:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var enemies_ready_to_move = 0
	for enemy in enemies:
		if enemy.ready_to_move:
			enemies_ready_to_move += 1
	
	if enemies_ready_to_move == enemies.size():
		for enemy in enemies:
			enemy.can_move = true
		return true
	else:
		return false

func _start_timers() -> void:
	spawn.start()
	move.start()
	can_move = true

func _on_gems_converted(gem_positions: Array) -> void:
	for gem_position in gem_positions:
		spawn_enemy(gem_position)
