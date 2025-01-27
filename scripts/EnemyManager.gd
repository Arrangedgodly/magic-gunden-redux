extends Node

@onready var spawn: Timer = $Spawn
@onready var move: Timer = $Move
@onready var map: Node2D = %Map
@onready var enemies: Node2D = %Enemies

const ENEMY = preload("res://scenes/enemy.tscn")

func _ready() -> void:
	spawn.timeout.connect(_on_spawn_timeout)
	move.timeout.connect(_on_move_timeout)
	
	spawn_enemy()

func spawn_enemy() -> void:
	var spawn_tile = map.choose_spawn_location()
	var enemy_scene = ENEMY.instantiate()
	enemies.add_child(enemy_scene)
	enemy_scene.position = spawn_tile.position

func _on_spawn_timeout() -> void:
	spawn_enemy()

func _on_move_timeout() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.can_move = true
