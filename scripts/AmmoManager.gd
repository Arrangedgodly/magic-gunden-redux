extends Node2D

@onready var gem_manager: Node2D = %GemManager
@onready var reload: Timer = $Reload

var ammo: int = 0
var clip_size: int = 6
var active_clip: int = 0

func _ready() -> void:
	gem_manager.gems_scored.connect(_on_gems_scored)
	reload.timeout.connect(_on_reload_timeout)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		reload.start()

func _process(delta: float) -> void:
	if active_clip == 0 and ammo > 0 and reload.is_stopped():
		reload.start()

func _on_gems_scored(gem_count: int) -> void:
	ammo += gem_count

func _on_reload_timeout() -> void:
	var ammo_to_load = clip_size - active_clip
	ammo -= ammo_to_load
	active_clip += ammo_to_load
