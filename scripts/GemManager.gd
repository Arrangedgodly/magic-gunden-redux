extends Node2D

@onready var spawn: Timer = $Spawn
@onready var map: Node2D = %Map
@onready var gems: Node2D = %Gems
@onready var player: CharacterBody2D = %Player

const GEM = preload("res://scenes/gem.tscn")

var collected_gems = []

func _ready() -> void:
	spawn.timeout.connect(_on_spawn_timeout)
	player.game_start.connect(_start_timer)
	player.move_complete.connect(update_gem_positions)
	
	_on_spawn_timeout()
	
func _on_spawn_timeout() -> void:
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

func update_gem_positions(positions: Array) -> void:
	for i in range(collected_gems.size()):
		if i + 1 < positions.size():
			var gem = collected_gems[i]
			var target_pos = positions[i]
			if gem.position != target_pos:
				var tween = create_tween()
				tween.tween_property(gem, "position", target_pos, 0.5)
