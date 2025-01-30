extends CharacterBody2D
signal game_start

@onready var map: Node2D = %Map
@onready var move: Timer = $Move
@onready var pickup_zone: Area2D = $PickupZone

var can_move: bool = false
var current_direction
var game_started: bool = false
var gem_count: int = 0
var trail = []

const DIRECTIONS = {
	"left": Vector2(-32, 0),
	"right": Vector2(32, 0),
	"up": Vector2(0, -32),
	"down": Vector2(0, 32)
}

func _ready() -> void:
	var spawn_tile = map.choose_spawn_location()
	self.position = spawn_tile.position
	move.timeout.connect(_on_move_timeout)
	pickup_zone.death.connect(_on_death)
	pickup_zone.gem_retreived.connect(_on_gem_retreived)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		if current_direction == DIRECTIONS.down:
			return
		set_direction(DIRECTIONS.up)
	
	if event.is_action_pressed("down"):
		if current_direction == DIRECTIONS.up:
			return
		set_direction(DIRECTIONS.down)
	
	if event.is_action_pressed("left"):
		if current_direction == DIRECTIONS.right:
			return
		set_direction(DIRECTIONS.left)
	
	if event.is_action_pressed("right"):
		if current_direction == DIRECTIONS.left:
			return
		set_direction(DIRECTIONS.right)

func _process(delta: float) -> void:
	if can_move:
		can_move = false
		var tween = create_tween()
		var target_position = self.position + current_direction
		tween.tween_property(self, "position", target_position, .5)
	
func _on_move_timeout() -> void:
	can_move = true

func set_direction(new_direction: Vector2) -> void:
	current_direction = new_direction
	if not game_started:
		game_started = true
		move.start()
		can_move = true
		game_start.emit()

func _on_death() -> void:
	print("Player killed")
	
func _on_gem_retreived() -> void:
	print("Gem Retreived")
