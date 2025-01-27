extends Area2D

var occupied: bool = false
var detector_count: int = 0
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if not (body is TileMapLayer):
		trigger_occupied()

func _on_body_exited(body: Node2D) -> void:
	if not (body is TileMapLayer):
		occupied = false
		collision.debug_color = Color(0, 0.6, 0.7, 0.42)

func trigger_occupied() -> void:
	occupied = true
	collision.debug_color = Color(0.7, 0, 0, 0.42)

func check_detector() -> bool:
	if detector_count < 2:
		return true
	else:
		return false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("detectors"):
		print("Detector entered " + self.name)
		detector_count += 1

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("detectors"):
		print("Detector exited " + self.name)
		detector_count -= 1
