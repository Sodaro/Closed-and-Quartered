extends Node

@export var levels: Array[PackedScene]

var current_level_index: int = 0
var current_level: Level

const _wipe_in_duration: float = 0.15
const _wipe_in_idle_duration: float = 0.85
const _wipe_out_duration: float = 0.75
const _wipe_out_idle_duration: float = 0.25

func _ready() -> void:
	$CanvasLayer/Wipe.wipe_in_finished.connect(_wipe_in_finished)
	$CanvasLayer/Wipe.wipe_out_finished.connect(_wipe_out_finished)
	show_main_menu()
	
func show_hud() -> void:
	HUD.visible = true
	$CanvasLayer/MainMenu.visible = false
	$CanvasLayer/WinScreen.visible = false
	
func show_main_menu() -> void:
	$CanvasLayer/MainMenu.visible = true
	HUD.visible = false
	$CanvasLayer/WinScreen.visible = false

	
func show_win_screen() -> void:
	$CanvasLayer/WinScreen.visible = true
	HUD.visible = false
	$CanvasLayer/MainMenu.visible = false
	
func handle_game_completed():
	current_level_index = levels.size()
	$CanvasLayer/Wipe.start_wipe_in(_wipe_in_duration)

func _wipe_out_finished() -> void:
	get_tree().paused = false


func _on_main_menu_start_game_pressed() -> void:
	current_level_index = 0
	$CanvasLayer/Wipe.start_wipe_in(_wipe_in_duration, _wipe_in_idle_duration)
	pass # Replace with function body.
	
func _handle_level_completed(_level: Level) -> void:
	current_level_index += 1
	load_out_level()
	
func load_out_level() -> void:
	get_tree().paused = true
	$CanvasLayer/Wipe.start_wipe_in(_wipe_in_duration, _wipe_in_idle_duration)
	
func _wipe_in_finished() -> void:
	if current_level != null:
		current_level.level_completed.disconnect(_handle_level_completed)
		current_level.queue_free()
		current_level.visible = false
		
	if current_level_index == -1:
		$CanvasLayer/Wipe.start_wipe_out(_wipe_out_duration, _wipe_out_idle_duration)
		show_main_menu()
	elif current_level_index <= levels.size() - 1:
		load_level(current_level_index)
	else:
		$CanvasLayer/Wipe.start_wipe_out(_wipe_out_duration, _wipe_out_idle_duration)
		show_win_screen()

func load_level(index: int) -> void:
	current_level_index = index
	current_level = levels[current_level_index].instantiate()
	
	current_level.level_completed.connect(_handle_level_completed)
	current_level.level_restart.connect(_handle_level_restart)
	
	current_level.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(current_level)
	current_level.setup()

	show_hud()
	$CanvasLayer/Wipe.start_wipe_out(_wipe_out_duration, _wipe_out_idle_duration)

func _handle_level_restart() -> void:
	load_out_level()

func _on_win_back_button_pressed() -> void:
	current_level_index = -1
	$CanvasLayer/Wipe.start_wipe_in(_wipe_in_duration, _wipe_in_idle_duration)
