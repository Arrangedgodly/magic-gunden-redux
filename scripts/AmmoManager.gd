extends Node2D
signal projectile_fired

@onready var gem_manager: Node2D = %GemManager
@onready var reload: Timer = $Reload
@onready var ammo_label: Label = $CanvasLayer/Control/AmmoLabel

var ammo: int = 0
var clip_size: int = 6
var active_clip: int = 0

func _ready() -> void:
	gem_manager.gems_scored.connect(_on_gems_scored)
	reload.timeout.connect(_on_reload_timeout)
	
	_handle_ammo_label()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		reload.start()
	if event.is_action_pressed("shoot"):
		if _fire_projectile():
			projectile_fired.emit()

func _process(_delta: float) -> void:
	if active_clip == 0 and ammo > 0 and reload.is_stopped():
		reload.start()

func _on_gems_scored(gem_count: int) -> void:
	ammo += gem_count
	
	_handle_ammo_label()

func _on_reload_timeout() -> void:
	var ammo_to_load = clip_size - active_clip
	
	if ammo > ammo_to_load:
		ammo -= ammo_to_load
		active_clip += ammo_to_load
	else:
		active_clip += ammo
		ammo = 0
		
	_handle_ammo_label()

func _fire_projectile() -> bool:
	if active_clip > 0:
		active_clip -= 1
		_handle_ammo_label()
		return true
	else:
		return false

func _handle_ammo_label() -> void:
	ammo_label.text = "Ammo Storage: " + str(ammo) + " / Active Clip: " + str(active_clip)
