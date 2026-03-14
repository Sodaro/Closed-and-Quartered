@icon("res://assets/art/level_icon.png")
extends Node2D
class_name Level

@export var bg_color = Color.BLACK
@export var fg_color = Color.WHITE
@export var level_exit: LevelExit
@export var player: PlayerCharacter

var camera_scene: PackedScene = load("res://player/player_camera.tscn")
var camera: PlayerCamera

signal level_completed(level: Level)
signal level_restart

func setup() -> void:
	camera = camera_scene.instantiate()
	camera.player = player
	add_child(camera)
	camera.enabled = true
	camera.make_current()
	camera.global_position = player.global_position
	level_exit.player_reached_level_exit.connect(_on_player_reached_exit)
	Helpers.LEVEL_ROOT_NODE = self
	Helpers.PLAYER = player
	player.player_died.connect(_on_player_died)
	RenderingServer.set_default_clear_color(bg_color)
	RenderingServer.global_shader_parameter_set("bg_color", bg_color)
	RenderingServer.global_shader_parameter_set("fg_color", fg_color)
	pass

func _on_player_reached_exit(in_player: PlayerCharacter, level_exit: LevelExit):
	level_completed.emit(self)
	
func _on_player_died():
	level_restart.emit()
