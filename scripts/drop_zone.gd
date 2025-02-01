extends Area2D

var gem_count: int = 0
var can_capture: bool = false
@onready var label: Label = $Label

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("gems") and body.picked_up:
		body.capture_point_count += 1
		gem_count += 1
		can_capture = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("gems") and body.picked_up:
		body.capture_point_count -= 1
		gem_count -= 1
		if gem_count == 0:
			can_capture = false

func _process(delta: float) -> void:
	if can_capture:
		label.add_theme_color_override("font_color", Color.GREEN_YELLOW)
	else:
		label.add_theme_color_override("font_color", Color.WHITE)
