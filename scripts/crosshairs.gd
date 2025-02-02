extends Sprite2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("aim-up"):
		_change_position(Vector2(0, -32))
	
	if event.is_action_pressed("aim-down"):
		_change_position(Vector2(0, 32))
	
	if event.is_action_pressed("aim-left"):
		_change_position(Vector2(-32, 0))
		
	if event.is_action_pressed("aim-right"):
		_change_position(Vector2(32, 0))

func set_starting_position(new_position: Vector2) -> void:
	position = new_position

func _change_position(new_position: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.25)
