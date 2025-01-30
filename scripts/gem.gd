extends CharacterBody2D

var picked_up: bool = false

func trigger_pick_up() -> void:
	picked_up = true
