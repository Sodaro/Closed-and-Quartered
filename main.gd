extends Node

@export var levels: Array[PackedScene]
@export var songs_per_level: Array[AudioStream]
@export var menu_song: AudioStream

var current_level_index: int = -1
var current_level: Level

const _wipe_in_duration: float = 0.15
const _wipe_in_idle_duration: float = 0.85
const _wipe_out_duration: float = 0.75
const _wipe_out_idle_duration: float = 0.25

var level_first_load: bool

func _ready() -> void:
	get_window().min_size = Vector2(640, 360)
	$CanvasLayer/Wipe.wipe_in_finished.connect(_wipe_in_finished)
	$CanvasLayer/Wipe.wipe_out_finished.connect(_wipe_out_finished)
	show_main_menu()
	$MusicPlayer.play_song(menu_song)
	$CanvasLayer/PauseMenu.continue_pressed.connect(_unpause_game)
	
	
func _pause_game() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	$CanvasLayer/PauseMenu.visible = true
	
func _unpause_game() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = false
	$CanvasLayer/PauseMenu.visible = false
	
func _process(_delta: float) -> void:
	if current_level_index < 0 || current_level_index >= levels.size():
		return
		
	if Input.is_action_just_pressed("ui_cancel"):
		if $CanvasLayer/PauseMenu.visible:
			_unpause_game()
		else:
			_pause_game()
	
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
	if current_level_index == levels.size() || current_level_index < 0:
		$MusicPlayer.play_song(menu_song)
	else:
		$MusicPlayer.play_song(songs_per_level[current_level_index])
	

func _on_main_menu_start_game_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	current_level_index = 0
	level_first_load = true
	$CanvasLayer/Wipe.start_wipe_in(_wipe_in_duration, _wipe_in_idle_duration)
	pass # Replace with function body.
	
func _handle_level_completed(_level: Level) -> void:
	current_level_index += 1
	level_first_load = true
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
	current_level.setup(level_first_load)

	show_hud()
	$CanvasLayer/Wipe.start_wipe_out(_wipe_out_duration, _wipe_out_idle_duration)

func _handle_level_restart() -> void:
	level_first_load = false
	load_out_level()

func _on_win_back_button_pressed() -> void:
	current_level_index = -1
	$CanvasLayer/Wipe.start_wipe_in(_wipe_in_duration, _wipe_in_idle_duration)
