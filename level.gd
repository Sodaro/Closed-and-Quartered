@icon("res://assets/art/level_icon.png")
extends Node2D
class_name Level

@export var bg_color = Color.BLACK
@export var fg_color = Color.WHITE
@export var level_exit: LevelExit
@export var collectible: LevelCollectible
@export var player: PlayerCharacter

var camera_scene: PackedScene = load("res://player/player_camera.tscn")
var camera: PlayerCamera

signal level_completed(level: Level)
signal level_restart

var camera_going_to_collectible: bool
var camera_going_to_exit: bool

func setup(show_level_goals: bool) -> void:
	camera = camera_scene.instantiate()
	camera.player = player
	add_child(camera)
	camera.enabled = true
	camera.make_current()
	camera.global_position = player.global_position
	#if show_level_goals:
		#camera.go_to_position(collectible.global_position, 1.0, 0.5, 1.0)
		#camera.reached_position.connect(_handle_camera_reached_position)
	camera_going_to_collectible = true
	level_exit.player_reached_level_exit.connect(_on_player_reached_exit)
	Helpers.LEVEL_ROOT_NODE = self
	Helpers.PLAYER_CAMERA = camera
	Helpers.PLAYER = player
	player.player_died.connect(_on_player_died)
	RenderingServer.set_default_clear_color(bg_color)
	RenderingServer.global_shader_parameter_set("bg_color", bg_color)
	RenderingServer.global_shader_parameter_set("fg_color", fg_color)
	pass

func _handle_camera_reached_position() -> void:
	if camera_going_to_collectible:
		camera_going_to_collectible = false
		camera_going_to_exit = true
		camera.go_to_position(level_exit.global_position, 1.0, 1.0, 1.0)
	elif camera_going_to_exit:
		camera_going_to_exit = false
		camera_going_to_collectible = false
		camera.return_to_player(0.5)
	else:
		camera.reached_position.disconnect(_handle_camera_reached_position)

func _on_player_reached_exit(in_player: PlayerCharacter, level_exit: LevelExit):
	ComponentManager.deregister_all_components()
	level_completed.emit(self)
	
func _on_player_died():
	ComponentManager.deregister_all_components()
	level_restart.emit()
