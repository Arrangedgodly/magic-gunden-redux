extends CharacterBody2D
signal game_start
signal game_end
signal move_complete(positions: Array)
signal release_gems

@onready var map: Node2D = %Map
@onready var move: Timer = $Move
@onready var pickup_zone: Area2D = $PickupZone
@onready var crosshairs: Sprite2D = $Crosshairs

var can_move: bool = false
var trigger_drop: bool = false
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
const DIRECTIONS_ARRAY = [DIRECTIONS.left, DIRECTIONS.right, DIRECTIONS.up, DIRECTIONS.down]

func _ready() -> void:
	var spawn_tile = map.choose_spawn_location()
	self.position = spawn_tile.position
	move.timeout.connect(_on_move_timeout)
	pickup_zone.death.connect(_on_death)
	pickup_zone.gem_retreived.connect(_on_gem_retreived)
	
	current_direction = DIRECTIONS_ARRAY.pick_random()
	crosshairs.set_starting_position(current_direction)

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
	
	if event.is_action_pressed("drop"):
		trigger_drop = true

func _process(_delta: float) -> void:
	if can_move:
		can_move = false
		if trigger_drop:
			trigger_drop = false
			gem_count = 0
			trail = []
			release_gems.emit()
		var tween = create_tween()
		var target_position = self.position + current_direction
		update_trail(target_position)
		tween.tween_property(self, "position", target_position, .5)
		
		move_complete.emit(trail)
	
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
	game_end.emit()
	
func _on_gem_retreived() -> void:
	gem_count += 1

func update_trail(new_position: Vector2) -> void:
	trail.push_back(new_position)
	while trail.size() > gem_count + 1:
		trail.pop_front()

func get_crosshairs_position() -> Vector2:
	return crosshairs.position
