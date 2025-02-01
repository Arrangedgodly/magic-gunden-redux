extends CharacterBody2D

signal collected(gem_collected: Node2D)

var picked_up: bool = false
var can_capture: bool = false
var capture_point_count: int = 0

@onready var label: Label = $Label

func trigger_pick_up() -> void:
	picked_up = true
	collected.emit(self)

func _process(delta: float) -> void:
	if capture_point_count > 0:
		can_capture = true
	else:
		can_capture = false
	
	if can_capture:
		label.add_theme_color_override("font_color", Color.GREEN)
	elif picked_up:
		label.add_theme_color_override("font_color", Color.YELLOW)
	else:
		label.add_theme_color_override("font_color", Color.PURPLE)
