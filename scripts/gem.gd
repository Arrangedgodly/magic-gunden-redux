extends CharacterBody2D
signal collected(gem_collected: Node2D)

var picked_up: bool = false

func trigger_pick_up() -> void:
	picked_up = true
	collected.emit(self)
