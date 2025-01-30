extends Area2D
signal gem_retreived
signal death

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("gems"):
		if body.picked_up:
			death.emit()
		else:
			body.trigger_pick_up()
			gem_retreived.emit()
	
	if body.is_in_group("enemies"):
		death.emit()
