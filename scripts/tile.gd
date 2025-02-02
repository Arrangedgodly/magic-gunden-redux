extends Area2D

var occupied: bool = false
var occupent_count: int = 0
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if occupent_count > 0:
		occupied = true
		collision.debug_color = Color(0.7, 0, 0, 0.42)
	else:
		occupied = false
		collision.debug_color = Color(0, 0.6, 0.7, 0.42)

func _on_body_entered(body: Node2D) -> void:
	if body is not TileMapLayer:
		occupent_count += 1

func _on_body_exited(body: Node2D) -> void:
	if body is not TileMapLayer:
		occupent_count -= 1
