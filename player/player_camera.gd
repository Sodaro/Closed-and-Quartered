extends Camera2D
class_name PlayerCamera

var player: PlayerCharacter

var has_look_position_override: bool
var is_returning_to_player: bool

var override_start_position: Vector2 = Vector2.ZERO
var override_target_position: Vector2 = Vector2.ZERO
var override_move_duration: float = 0.0
var override_active_time: float
var override_initial_wait: float
var override_total_duration

signal reached_position
var look_range: float = 100.0

#var camera_center_offset: Vector2 = Vector2(640, 360)

func go_to_position(target_position: Vector2, move_duration: float, initial_wait: float, reached_end_wait: float):
	has_look_position_override = true
	is_returning_to_player = false
	override_start_position = global_position
	override_target_position = target_position
	override_move_duration = move_duration
	override_initial_wait = initial_wait
	override_total_duration = initial_wait + move_duration + reached_end_wait
	override_active_time = 0
	
func return_to_player(move_duration: float):
	has_look_position_override = true
	is_returning_to_player = true
	override_start_position = global_position
	override_target_position = player.global_position
	override_move_duration = move_duration
	override_initial_wait = 0
	override_total_duration = move_duration
	override_active_time = 0
	
func handle_look_override() -> void:
	var move_time: float = override_active_time - override_initial_wait
	if move_time < 0:
		return
		
	var move_alpha: float = Helpers.clamp01(move_time / override_move_duration)
	global_position = lerp(override_start_position, override_target_position, move_alpha)
	if override_active_time >= override_total_duration:
		reached_position.emit()
		
	if is_returning_to_player && override_active_time >= override_total_duration:
		is_returning_to_player = false
		has_look_position_override = false
		

func _process(delta: float) -> void:
	if !has_look_position_override:
		var mouse_position: Vector2 = Helpers.get_global_mouse_position(get_viewport())
		var player_position: Vector2 = player.global_position
		var to_mouse: Vector2 = (mouse_position - player_position)
		if to_mouse.is_zero_approx():
			to_mouse = player.transform.x
		#var desired_dist: float = to_mouse.length()
		var clamped_dist: float = look_range
		var target_position: Vector2 = player_position + to_mouse.normalized() * clamped_dist
		if (target_position - global_position).length() < 15:
			return
		var new_position: Vector2 = lerp(global_position, target_position, minf(1.0, 10.0 * delta))
		global_position = new_position
	else:
		handle_look_override()
		override_active_time += delta
	
