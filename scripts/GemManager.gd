extends Node2D

@onready var spawn: Timer = $Spawn
@onready var map: Node2D = %Map
@onready var gems: Node2D = %Gems

const GEM = preload("res://scenes/gem.tscn")

func _ready() -> void:
	spawn.timeout.connect(_on_spawn_timeout)
	
func _on_spawn_timeout() -> void:
	var spawn_tile = map.choose_spawn_location()
	var gem_scene = GEM.instantiate()
	gems.add_child(gem_scene)
	gem_scene.position = spawn_tile.position
