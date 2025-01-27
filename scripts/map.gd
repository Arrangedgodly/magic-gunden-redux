extends Node2D

@onready var grid: TileMapLayer = $Grid

var tiles = []

const TILE = preload("res://scenes/tile.tscn")

func _ready() -> void:
	var i = 0
	var j = 0
	var grid_count = 1
	
	while i < 12:
		while j < 12:
			var area = TILE.instantiate()
			add_child(area)
			area.position = Vector2((j * 32) + 16, (i * 32) + 16)
			j += 1
		j = 0
		i += 1

func get_random_tile() -> Node2D:
	var tiles = get_tree().get_nodes_in_group("tiles")
	var random_tile = tiles.pick_random()
	return random_tile

func choose_spawn_location() -> Node2D:
	var tile = get_random_tile()
	var tile_found = 1
	while tile_found > 0:
		if tile.occupied:
			tile = get_random_tile()
			tile_found += 1
		else:
			tile_found = 0
	
	return tile
