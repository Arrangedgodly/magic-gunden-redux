extends Area2D
signal can_move
signal change_position

func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.is_in_group("detectors"):
		change_position.emit()
		return
		
	if area.is_in_group("tiles"):
		can_move.emit()
		return
	
	if area.is_in_group("border"):
		change_position.emit()
		return
	

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.is_in_group("enemies"):
		can_move.emit()
	elif body.is_in_group("player") and body.gem_count == 0:
		can_move.emit()
	else:
		change_position.emit()
