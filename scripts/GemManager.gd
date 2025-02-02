extends Node2D

signal gems_scored(gem_count: int)
signal gems_converted(gem_positions: Array)

@onready var spawn: Timer = $Spawn
@onready var map: Node2D = %Map
@onready var gems: Node2D = %Gems
@onready var player: CharacterBody2D = %Player

const GEM = preload("res://scenes/gem.tscn")

var collected_gems = []
var gems_captured: int = 0
var gems_to_enemies = []

func _ready() -> void:
	spawn.timeout.connect(_on_spawn_timeout)
	player.game_start.connect(_start_timer)
	player.move_complete.connect(update_gem_positions)
	player.release_gems.connect(release_gems)
	
	_spawn_gem()
	
func _on_spawn_timeout() -> void:
	_spawn_gem()

func _spawn_gem() -> void:
	var spawn_tile = map.choose_spawn_location()
	var gem_scene = GEM.instantiate()
	gems.add_child(gem_scene)
	gem_scene.collected.connect(collect_gem)
	gem_scene.position = spawn_tile.position

func _start_timer() -> void:
	spawn.start()

func collect_gem(gem: Node2D) -> void:
	if not gem in collected_gems:
		collected_gems.append(gem)
		_spawn_gem()

func update_gem_positions(positions: Array) -> void:
	for i in range(collected_gems.size()):
		if i + 1 < positions.size():
			var gem = collected_gems[i]
			var target_pos = positions[i]
			if gem.position != target_pos:
				var tween = create_tween()
				tween.tween_property(gem, "position", target_pos, 0.5)

func release_gems() -> void:
	for gem in collected_gems:
		if gem.can_capture:
			gems_captured += 1
		else:
			gems_to_enemies.append(gem.position)
		gem.queue_free()
	
	gems_scored.emit(gems_captured)
	gems_converted.emit(gems_to_enemies)
	
	reset_collected_gems()

func reset_collected_gems() -> void:
	gems_captured = 0
	gems_to_enemies = []
	collected_gems = []
