extends Area2D
signal enemy_killed

var direction : Vector2
var speed = 25
const up = Vector2(0, -1)
const down = Vector2(0, 1)
const left = Vector2(-1, 0)
const right = Vector2(1, 0)
const right_degrees = 0
const down_degrees = 90
const left_degrees = 180
const up_degrees = 270

func set_direction(new_dir: Vector2):
	direction = new_dir
	if direction == right:
		rotation_degrees = right_degrees
	if direction == down:
		rotation_degrees = down_degrees
	if direction == left:
		rotation_degrees = left_degrees
	if direction == up:
		rotation_degrees = up_degrees
	
func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.queue_free()
		enemy_killed.emit()
		queue_free()
	
	if body.is_in_group("gems"):
		queue_free()
