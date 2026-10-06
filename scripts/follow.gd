extends Node2D

const Rules = preload("res://scripts/rules.gd")
var rules = Rules.new()

func _ready() -> void:
	$SheetLens.make_current()

func _unhandled_input(event: InputEvent) -> void:
	var kind := ""
	if event.is_action_pressed("primary"):
		kind = "runner"
	elif event.is_action_pressed("leap"):
		kind = "anchor"
	if kind != "" and rules.take_roster(kind):
		if rules.pool_for(kind) <= 0:
			rules.revive(kind)
		get_tree().change_scene_to_file("res://scenes/opener.tscn")
