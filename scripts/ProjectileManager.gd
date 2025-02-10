extends Node2D

signal enemy_killed

@onready var ammo_manager: Node2D = %AmmoManager
@onready var player: CharacterBody2D = %Player
@onready var projectiles: Node2D = %Projectiles

const PROJECTILE = preload("res://scenes/projectile.tscn")

func _ready() -> void:
	ammo_manager.projectile_fired.connect(_on_projectile_fired)
	
func _on_projectile_fired() -> void:
	var projectile_direction = player.get_crosshairs_position()
	var new_projectile = _spawn_projectile()
	new_projectile.set_direction(projectile_direction)
	projectiles.add_child(new_projectile)

func _spawn_projectile() -> Node2D:
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = player.global_position
	new_projectile.enemy_killed.connect(_on_enemy_killed)
	return new_projectile

func _on_enemy_killed() -> void:
	enemy_killed.emit()
