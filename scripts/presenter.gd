extends Node3D

const Rules = preload("res://scripts/rules.gd")
var rules = Rules.new()
var peer := ENetMultiplayerPeer.new()

@onready var runner_mark: MeshInstance3D = $RunnerMark
@onready var anchor_mark: MeshInstance3D = $AnchorMark

func _ready() -> void:
	if not rules.raid_ready():
		_go("res://scenes/roster.tscn")
		return
	_tint(runner_mark, Color(0.3, 0.6, 0.9))
	_tint(anchor_mark, Color(0.9, 0.5, 0.2))

func _tint(mesh: MeshInstance3D, color: Color) -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.material_override = mat

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary"):
		rules.apply_hit("host", "runner", 5)
		_fit(runner_mark, "runner", 80)
	if event.is_action_pressed("leap"):
		rules.apply_hit("client", "anchor", 5)
		_fit(anchor_mark, "anchor", 120)

func _fit(mesh: MeshInstance3D, kind: String, full: int) -> void:
	var left := float(rules.pool_for(kind)) / float(full)
	mesh.scale = Vector3(1, maxf(left, 0.15), 1)

func _go(next_path: String) -> void:
	get_tree().change_scene_to_file(next_path)
